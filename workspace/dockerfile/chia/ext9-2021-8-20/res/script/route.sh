#!/usr/bin/env bash
# 设置默认路由走拨号口,且管理后任然可以进行连接

__init_rt_tables() {
    _table_name="252-manage"
    _is=$(nsenter --mount=/host/1/ns/mnt bash -c 'cat /etc/iproute2/rt_tables' | grep "$_table_name")
    if [[ "$_is"x == ""x ]]; then
        echo "echo '252     252-manage' >> /etc/iproute2/rt_tables" >/tmp/cmd.sh
        nsenter --mount=/host/1/ns/mnt bash "$_rootfs"/tmp/cmd.sh
        nsenter --mount=/host/1/ns/mnt ip route flush table "$_table_name"
    fi
}

__manage_route_table() {
    _table_name="252-manage"

    _is=$(nsenter --mount=/host/1/ns/mnt ip route list table 252-manage | grep default -c)
    if ((_is != 1)); then
        __init_rt_tables
        _nic=$(ip r | grep -v -E 'ppp|docker|br' | grep '\ssrc\s' | head -1 | awk '{print $3}')
        _wd=$(ip r | grep -v -E 'ppp|docker|br' | grep '\ssrc\s' | head -1 | head -1 | awk '{print $1}')
        _wg=$(ip r | grep "default.* dev\s$_nic" | head -1 | awk '{print $3}')
        if [[ "${_wg}" == "" ]]; then
            _wg=$(cat /etc/sysconfig/network-scripts/ifcfg-"$_nic" | grep 'GATEWAY' | awk -F '=' '{print $NF}')
        fi

        echo "$_nic $_wd $_wg"
        if [[ "$_wd$_wg" != "" ]]; then
            for a in {1..2}; do
                nsenter --mount=/host/1/ns/mnt ip rule del lookup "$_table_name"
            done
            nsenter --mount=/host/1/ns/mnt ip rule add from "$_wd" table "$_table_name"
            nsenter --mount=/host/1/ns/mnt ip route add default via "$_wg" table "$_table_name"
        fi

    fi

}

__main() {
    _ppp=$(ip a | grep -Eo 'ppp[0-9]{1,2}$' | head -1)
    _rootfs=$(nsenter --mount=/host/1/ns/mnt docker inspect $(cat /proc/self/cgroup | grep devices | cut -d/ -f3 | cut -c1-12) | jq -r ".[0].GraphDriver.Data.MergedDir")

    __manage_route_table
    if [[ "${_ppp}" != "" ]]; then
        ip route replace default dev "$_ppp"
    fi

}

__main

__help() {
    nsenter --mount=/host/1/ns/mnt ip route list table 252-manage

    ip route flush table 252-manage
}
