#!/bin/bash
# 技术支持 QQ1713829947 http://lwm.icu
# 设置容器内的网卡配置文件

__init_args() {
    _container_id=$(cat /proc/self/cgroup | grep devices | cut -d/ -f3 | cut -c1-12)
    _container_name=$(nsenter --mount=/host/1/ns/mnt docker inspect "$_container_id" | jq -r ".[0].Name")
    # _rootfs=$(nsenter --mount=/host/1/ns/mnt docker inspect "$_container_id" | jq -r ".[0].GraphDriver.Data.MergedDir")

    _container_name=${_container_name:1:99}
    _array=(${_container_name//-/ })

    _vlan=${_array[1]}
    _user=${_array[2]}
    _pwd=${_array[3]}
    _nic=${_array[4]}

    _user=${_user//_/@}

    _eth=/etc/sysconfig/network-scripts/ifcfg-ppp0
    _pap_secrets=/etc/ppp/pap-secrets
    _chap_secrets=/etc/ppp/chap-secrets
}

__write_pppoe_config() {

    echo 'USERCTL=yes' >$_eth
    echo 'BOOTPROTO=dialup' >>$_eth
    echo 'NAME=DSLppp0' >>$_eth
    echo 'DEVICE=ppp0' >>$_eth
    echo 'TYPE=xDSL' >>$_eth
    echo 'ONBOOT=no' >>$_eth
    echo 'PIDFILE=/var/run/pppoe-adsl.pid' >>$_eth
    echo 'FIREWALL=NONE' >>$_eth
    echo 'PING=.' >>$_eth
    echo 'PPPOE_TIMEOUT=80' >>$_eth
    echo 'LCP_FAILURE=30' >>$_eth
    echo 'LCP_INTERVAL=20' >>$_eth
    echo 'CLAMPMSS=1412' >>$_eth
    echo 'CONNECT_POLL=6' >>$_eth
    echo 'CONNECT_TIMEOUT=60' >>$_eth
    echo 'DEFROUTE=no' >>$_eth
    echo 'SYNCHRONOUS=no' >>$_eth
    echo 'ETH='"$_macvlan_name" >>$_eth
    echo 'PROVIDER=DSLppp0' >>$_eth
    echo 'USER='"$_user" >>$_eth
    echo 'PEERDNS=no' >>$_eth
    echo 'DEMAND=no' >>$_eth
    echo 'LINUX_PLUGIN=/usr/lib64/pppd/2.4.5/rp-pppoe.so' >>$_eth

    echo "'$_user' * '$_pwd'" >$_pap_secrets
    echo "'$_user' * '$_pwd'" >$_chap_secrets
}

__set_macvlan() {

    ip link add link "$_nic" name "$_nic.$_vlan" type vlan id "$_vlan"
    ip link set "$_nic.$_vlan" up

    if [[ "${MAC}" != "" ]]; then
        _address=$MAC
    else
        _address=$(echo "$_vlan.$_user.$_pwd" | md5sum | sed -e 's/^\(..\)\(..\)\(..\)\(..\)\(..\).*$/88:\1:\2:\3:\4:\5/')
    fi

    _mac_md5=$(echo "$_address" | md5sum)
    _macvlan_name=$(echo "$_nic.$_vlan.$_mac_md5" | cut -c1-15) # 名称最大长度15
    ip link add link "$_nic.$_vlan" dev "$_macvlan_name" address "$_address" type macvlan mode private
    ip link set "$_macvlan_name" up
}

__init_args "$@"
__set_macvlan
__write_pppoe_config
