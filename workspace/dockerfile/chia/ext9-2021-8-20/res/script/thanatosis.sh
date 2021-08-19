#!/usr/bin/env bash
# 解决线路长时间无数据经过,假死状态,进行重播操作

__thanatosis() {
    _date=$(date -d today +"%Y-%m-%d %H:%M:%S")
    _container_name=$1
    _ppp=$2

    _tx_now=$(echo "$_ifconfig_ppp_all" | grep "$_ppp" -A8 | grep 'TX packets')
    _rx_now=$(echo "$_ifconfig_ppp_all" | grep "$_ppp" -A8 | grep 'RX packets')
    _tx_last=$(cat "/apps/data/search/thanatosis/tx_last-$_ppp")
    _rx_last=$(cat "/apps/data/search/thanatosis/rx_last-$_ppp")

    echo "$_container_name"
    echo "$_container_name  $_ppp $_tx_now $_tx_last $_rx_now $_rx_last"

    if [[ "$_tx_now"x == "$_tx_last"x ]]; then
        echo "[$_date] $_container_name 线路5分钟TX无数据经过,即将重启容器重播" >>"$_log"
        nsenter --mount=/host/1/ns/mnt docker restart -t1 "$_container_name"

    else
        echo "$_tx_now" >/apps/data/search/thanatosis/tx_last-"$_ppp"
    fi

    if [[ "$_rx_now"x == "$_rx_last"x ]]; then
        echo "[$_date] $_container_name 线路5分钟RX无数据经过,即将重启容器重播" >>"$_log"
        nsenter --mount=/host/1/ns/mnt docker restart -t1 "$_container_name"
    else
        echo "$_rx_now" >/apps/data/search/thanatosis/rx_last-"$_ppp"
    fi

}

_for() {
    _ifconfig_ppp_all=$(ifconfig | grep -E 'ppp[0-9]{1,3}' -A8)
    _ifconfig_ppp_name=$(ifconfig | grep -Eo 'ppp[0-9]{1,3}')
    for _ppp in $_ifconfig_ppp_name; do
        _container_name=$(cat /apps/data/search/ppp/"$_ppp" | awk '{print $1}')
        __thanatosis "$_container_name" "$_ppp"
    done

}
_for

__init() {
    declare -i _progressive
    _progressive=1
    _log=/apps/data/pppoe.log
    _ifconfig_ppp_all=$(ifconfig | grep -E 'ppp[0-9]{1,3}' -A8)
    _ifconfig_ppp_name=$(ifconfig | grep -Eo 'ppp[0-9]{1,3}')

    for _ppp in $_ifconfig_ppp_name; do
        _tx_now=$(echo "$_ifconfig_ppp_all" | grep "$_ppp" -A8 | grep 'TX packets')
        _rx_now=$(echo "$_ifconfig_ppp_all" | grep "$_ppp" -A8 | grep 'RX packets')

        echo "$_tx_now" >/apps/data/search/thanatosis/tx_last-"$_ppp"
        echo "$_rx_now" >/apps/data/search/thanatosis/rx_last-"$_ppp"
    done

}
__init

while [ true ]; do
    /bin/sleep 10
    /apps/script/route.sh &
    ping -c1 223.6.6.6
    let _progressive++
    if [ $_progressive -ge 30 ]; then
        _progressive=1
        _for
    fi

done
