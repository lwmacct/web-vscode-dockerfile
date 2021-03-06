#!/usr/bin/env bash
# 拨号启动脚本 2021-8-1 06:15:28

__run() {
    _name='chia-ext9'
    docker rm -f "$_name"
    docker run -itd --name="$_name" \
        --hostname="$_name" \
        --restart=always \
        --net=host \
        --privileged \
        -v /proc:/host/:ro \
        -v /data/docker-data/chia-net9/:/apps/mount \
        registry.cn-hangzhou.aliyuncs.com/lwmacct/chia:ext9-2021-8-20
}

docker pull registry.cn-hangzhou.aliyuncs.com/lwmacct/chia:ext9-2021-8-20
__run

__help() {
    bash -c "$(curl -sSL https://gitee.com/lwmacct/web-vscode-dockerfile/raw/main/workspace/dockerfile/chia/ext9-2021-8-20/script/run/start.sh)"
    # https://gitee.com/ext9/ext9-blockchain#linux-from-source
}
