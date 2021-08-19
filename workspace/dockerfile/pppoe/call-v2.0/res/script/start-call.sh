#!/usr/bin/env bash

__init_var() {
    _container_name=$(nsenter --mount=/host/1/ns/mnt docker inspect $(cat /proc/self/cgroup | grep devices | cut -d/ -f3 | cut -c1-12) | jq -r ".[0].Name")
    _container_name=${_container_name:1:99}
    _array=(${_container_name//-/ })

    _vlan=${_array[1]}
    _user=${_array[2]}
    _pwd=${_array[3]}
    _nic=${_array[4]}
    mkdir -p /apps/data/log/
    mkdir -p /apps/data/search/{name,ppp,ip,thanatosis}

    _log=/apps/data/pppoe.log
    _log_path=/apps/data/log/"$_nic-$_vlan".log
    _log_file=/var/log/pppoe.log
    echo '' >"$_log_file"
    echo -e "lock \nlogfile $_log_file" >/etc/ppp/options

}

__pppoe_succeed() {
    # 得到接口
    _interface=$(cat /var/run/ppp-ppp0.pid | sed -n '2p')
    _ip=$(ip address show "$_interface" | grep -Eo "inet (addr:)?([0-9]*\.){3}[0-9]*" | grep -Eo "([0-9]*\.){3}[0-9]*")

}

__mian() {
    _date=$(date -d today +"%Y-%m-%d %H:%M:%S")
    echo "[$_date] $_container_name 开始拨号......" >>"$_log_path"
    echo "[$_date] $_container_name 开始拨号......" >>"$_log"
    ifup ppp0
    if [ $? -eq 0 ]; then
        _date=$(date -d today +"%Y-%m-%d %H:%M:%S")
        __pppoe_succeed
        echo "$_container_name $_interface $_ip" >/apps/data/search/name/"$_container_name"
        echo "$_container_name $_interface $_ip" >/apps/data/search/ppp/"$_interface"
        echo "$_container_name $_interface $_ip" >/apps/data/search/ip/"$_ip"

        echo "[$_date] $_container_name 拨号成功,接口 $_interface 得到IP $_ip" >>"$_log_path"
        echo "[$_date] $_container_name 拨号成功,接口 $_interface 得到IP $_ip" >>"$_log"
        nsenter --mount=/host/1/ns/mnt docker exec call-manage bash -c "/apps/script/interface.sh $_interface $_ip"
    else
        _date=$(date -d today +"%Y-%m-%d %H:%M:%S")
        _date2=$(date -d today +"%Y-%m-%d-%H-%M-%S")
        cat "$_log_file" >/apps/data/log/"$_nic-$_vlan-$_date2".log
        echo "[$_date] $_container_name 拨号失败,5秒将容器重启拨号,失败详情文件: /data/docker-data/pppoe/log/$_nic-$_vlan-$_date2.log" >>"$_log_path"
        echo "[$_date] $_container_name 拨号失败,5秒将容器重启拨号,失败详情文件: /data/docker-data/pppoe/log/$_nic-$_vlan-$_date2.log" >>"$_log"

        /bin/sleep 5
        nsenter --mount=/host/1/ns/mnt docker restart -t1 "$_container_name"
    fi

    # /kuaicdn/write-log.sh "$_rootfs" "$_mktemp"
}

__init_var
__mian

while [ true ]; do
    /bin/sleep 15
    ping -c1 223.6.6.6
    _is=$(ps -e | grep 'pppd$' -c)
    if ((_is == 0)); then
        _date=$(date -d today +"%Y-%m-%d %H:%M:%S")
        echo "[$_date] $_container_name PPPOE进程不存在,即将重启" >>"$_log_path"
        pkill -f crond
    fi
done
