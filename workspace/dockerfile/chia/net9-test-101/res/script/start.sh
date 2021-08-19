#!/usr/bin/env bash
# 启动新容器和删除无效容器

__run_pppoe() {
    _name=$1
    _mac=$2
    nsenter --mount=/host/1/ns/mnt docker run -itd --name="$_name" \
        --hostname="$_name" \
        --restart=always \
        --net=host \
        --privileged \
        -v /proc:/host/:ro \
        -v /data/docker-data/pppoe/:/apps/data \
        -e "MAC=$_mac" \
        registry.cn-hangzhou.aliyuncs.com/lwmacct/pppoe:call-v2.2
}

__del_nullity() {
    _run_data=$(cat /apps/data/run.txt)
    _list=$(nsenter --mount=/host/1/ns/mnt docker ps -a | grep 'call-[0-9]' | awk '{print $NF}')
    for item in $_list; do
        _is=$(echo "$_run_data" | grep "$item" -c)
        if ((_is == 0)); then
            nsenter --mount=/host/1/ns/mnt docker rm -f "$item"
        fi
    done
}

__main() {
    # 删除旧版拨号容器
    nsenter --mount=/host/1/ns/mnt docker rm -f $(nsenter --mount=/host/1/ns/mnt docker ps -a | grep -E '\s[0-9a-z]{12}.*(second|minute).*call-[0-9]' | awk '{print $1}') # 这一行$()不要有双引号

    echo >/apps/data/run.txt
    while read _line; do
        _name=$(echo "$_line" | awk '{print "call-"$1"-"$2"-"$3"-"$4}')
        _mac=$(echo "$_line" | awk '{print $5}')
        _name=${_name//@/_}
        if [[ "${_name}" != "call----" ]]; then
            __run_pppoe "$_name" "$_mac" >/dev/null 2>&1
            echo "$_name" >>/apps/data/run.txt
        fi
    done </apps/data/account.txt
    __del_nullity

}

__main
