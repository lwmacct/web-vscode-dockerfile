#!/usr/bin/env bash

__run() {
    _name=$1
    docker rm -f "$_name"
    docker pull registry.cn-hangzhou.aliyuncs.com/lwmacct/ikuai:centos-kvm-ls10
    docker run -itd --name="$_name" \
        --hostname="$_name" \
        --restart=always \
        --net=host \
        --privileged \
        -v /proc:/host/:ro \
        -v /data/docker-data/kvm-ikuai/:/apps/data \
        registry.cn-hangzhou.aliyuncs.com/lwmacct/ikuai:centos-kvm-ls10

}

__run kvm-ikuai-tools

__help() {
    bash -c "$(curl -sSL https://gitee.com/lwmacct/web-vscode-dockerfile/raw/main/workspace/dockerfile/ikuai/centos-kvm-ls10/script/start.sh)"
}
