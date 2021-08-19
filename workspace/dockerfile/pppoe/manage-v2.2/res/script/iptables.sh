#!/usr/bin/env bash
# 设置分流

__init_rt_tables() {

    _is=$(nsenter --mount=/host/1/ns/mnt bash -c 'cat /etc/iproute2/rt_tables' | grep t"$_mark")
    if [[ "$_is"x == ""x ]]; then
        echo "echo '$_mark     t$_mark' >> /etc/iproute2/rt_tables" >/tmp/cmd.sh
        nsenter --mount=/host/1/ns/mnt bash "$_rootfs"/tmp/cmd.sh
    fi
}

__init_proc() {
    nsenter --mount=/host/1/ns/mnt bash -c 'echo 2 > /proc/sys/net/ipv4/conf/all/rp_filter'
    nsenter --mount=/host/1/ns/mnt bash -c 'echo 2 > /proc/sys/net/ipv4/conf/default/rp_filter'
    nsenter --mount=/host/1/ns/mnt bash -c 'echo 2 > /proc/sys/net/ipv4/conf/'"$_interface"'/rp_filter'
}

__iptables_route() {

    nsenter --mount=/host/1/ns/mnt ip route flush table t"$_mark"
    nsenter --mount=/host/1/ns/mnt ip route add 0/0 dev "$_interface" table t"$_mark"

    for a in {1..3}; do
        nsenter --mount=/host/1/ns/mnt ip rule del fwmark "$_mark16" table t"$_mark" pref 100
        nsenter --mount=/host/1/ns/mnt ip rule del from $(nsenter --mount=/host/1/ns/mnt ip rule | grep t"$_mark" | grep -v 'fwmark' | awk '{print $3}' | head -1)
    done

    nsenter --mount=/host/1/ns/mnt ip rule add fwmark "$_mark16" table t"$_mark" pref 100
    nsenter --mount=/host/1/ns/mnt ip rule add from "$_ip" table t"$_mark" pref 200

}

__iptables_mangle_input() {
    iptables -t mangle -A INPUT -i "$_interface" -m state --state NEW -j MARK --set-mark "$_mark16"
}

__iptables_mangle_output() {
    # 两种方式可选,可清空链,或搜索删除,如果链上有其他规则,那么禁用清空解开下面 for
    # iptables -t mangle -F OUTPUT

    for a in {1..2}; do
        iptables -t mangle -D OUTPUT $(iptables -t mangle -nvL OUTPUT --line-numbers | grep 'state NEW HMARK mod' | awk '{print $1}' | head -1)
        iptables -t mangle -D OUTPUT $(iptables -t mangle -nvL OUTPUT --line-numbers | grep 'state NEW CONNMARK save' | awk '{print $1}' | head -1)
        iptables -t mangle -D OUTPUT $(iptables -t mangle -nvL OUTPUT --line-numbers | grep 'state RELATED,ESTABLISHED CONNMARK restore' | awk '{print $1}' | head -1)
    done

    iptables -t mangle -A OUTPUT -m state --state NEW -j HMARK --hmark-tuple src,sport,dst,dport --hmark-mod "$_route_number" --hmark-rnd 0xcafeface --hmark-offset 0x65
    iptables -t mangle -A OUTPUT -m state --state NEW -j CONNMARK --save-mark --nfmask 0xffffffff --ctmask 0xffffffff
    iptables -t mangle -A OUTPUT -m state --state RELATED,ESTABLISHED -j CONNMARK --restore-mark --nfmask 0xffffffff --ctmask 0xffffffff

}

__iptables_nat() {
    for a in {1..2}; do
        iptables -t nat -D POSTROUTING $(iptables -t nat -nvL POSTROUTING --line-numbers | grep 'ppp+' | awk '{print $1}' | head -1)
    done
    iptables -t nat -A POSTROUTING -o ppp+ -j MASQUERADE
}

__ppp_for() {
    iptables -t mangle -F INPUT
    _ppp=$(ip a | grep -Eo 'ppp[0-9]{1,2}$' | grep -Eo '[0-9]{1,2}' | sort -n)
    for _ppp_num in $_ppp; do
        _interface="ppp$_ppp_num"
        _mark=$(echo "$_ppp_num + 101" | bc) # 把 pppoe 设备名作为路由表名以及标记
        _mark16=0x$(printf "%x" "$_mark")
        _ip=$(ip r | grep "$_interface\s.*src" | awk '{print $NF}')
        # echo -e "$_interface \t $_ip"

        __init_rt_tables
        __init_proc
        __iptables_route
        __iptables_mangle_input

    done

    __iptables_mangle_output
    __iptables_nat
    iptables -t mangle -A INPUT -i ppp+ -m state --state NEW -j CONNMARK --save-mark --nfmask 0xffffffff --ctmask 0xffffffff

}

__mian() {
    _rootfs=$(nsenter --mount=/host/1/ns/mnt docker inspect $(cat /proc/self/cgroup | grep devices | cut -d/ -f3 | cut -c1-12) | jq -r ".[0].GraphDriver.Data.MergedDir")
    _iptables_num=$(iptables -t mangle -nvL INPUT --line-numbers | grep -E 'ppp[0-9]{1,2}' -c)
    _route_number=$(ip a | grep -Eo 'ppp[0-9]{1,2}$' | grep -Eo '[0-9]{1,2}' -c)
    if ((_iptables_num != _route_number)); then
        __ppp_for
    fi
}

while true; do
    /bin/sleep 5
    __mian
done
