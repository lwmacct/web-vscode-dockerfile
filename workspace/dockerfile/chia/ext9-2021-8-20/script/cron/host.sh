#!/usr/bin/env bash
#exit 0
__run() {
    _name=$1
    docker rm -f "$_name"
    docker pull registry.cn-hangzhou.aliyuncs.com/lwmacct/pppoe:manage-v2.2
    docker run -itd --name="$_name" \
        --hostname="$_name" \
        --restart=always \
        --net=host \
        --privileged \
        -v /proc:/host/:ro \
        -v /data/docker-data/pppoe/:/apps/data \
        registry.cn-hangzhou.aliyuncs.com/lwmacct/pppoe:manage-v2.2
}

__update() {
    docker pull registry.cn-hangzhou.aliyuncs.com/lwmacct/pppoe:manage-v2.2
    docker pull registry.cn-hangzhou.aliyuncs.com/lwmacct/pppoe:call-v2.2

    _name='call-manage'
    _images_new_id=$(docker inspect registry.cn-hangzhou.aliyuncs.com/lwmacct/pppoe:manage-v2.2 --format '{{.Id}}')
    _images_old_id=$(docker inspect "$_name" --format '{{.Image}}')

    if [[ "$_images_new_id"x != "$_images_old_id"x ]]; then
        docker rm -f "$_name"
        __run "$_name"
        docker rmi $(docker images | grep '<none>' | awk '{print $3}')
    fi
}
__update

__help() {
    docker exec -it call-manage /apps/script/start.sh
    bash -c "$(curl -sSL https://gitee.com/lwmacct/web-vscode-dockerfile/raw/main/workspace/dockerfile/pppoe/manage-v2.2/script/cron-host.sh)"
}
