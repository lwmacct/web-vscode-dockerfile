#!/usr/bin/env bash
# 拨号启动脚本 2021-8-1 06:15:28

__run_pppoe_manage() {
    _name='call-manage'
    docker rm -f "$_name"
    docker pull registry.cn-hangzhou.aliyuncs.com/lwmacct/pppoe:manage-v2.0
    docker run -itd --name="$_name" \
        --hostname="$_name" \
        --restart=always \
        --net=host \
        --privileged \
        -v /proc:/host/:ro \
        -v /data/docker-data/pppoe/:/apps/data \
        registry.cn-hangzhou.aliyuncs.com/lwmacct/pppoe:manage-v2.0
}
__run_pppoe_manage

__help() {
    bash -c "$(curl -sSL https://gitee.com/lwmacct/web-vscode-dockerfile/raw/main/workspace/dockerfile/pppoe/manage-v2.0/script/start.sh)"
}
