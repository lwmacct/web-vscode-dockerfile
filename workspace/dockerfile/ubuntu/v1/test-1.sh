#!/usr/bin/env bash

__run_ubuntu() {
    docker rm -f ubuntu
    docker run -itd --name=ubuntu \
        --restart=always \
        --net=host \
        --privileged \
        -v /proc:/host/:ro \
        -v /data/docker-data/ubuntu/:/apps/mount \
        registry.cn-hangzhou.aliyuncs.com/lwmacct/ubuntu:v1
}
__run_ubuntu

apt install virt-* virtinst libvirt-clients libvirt-bin qemu-kvm net-tools bridge-utils

apt install virt-* virtinst qemu-kvm net-tools bridge-utils

__AAA() {
    docker run -itd \
        --name=ubuntu-desktop \
        --restart=always \
        --net=host \
        --privileged \
        -p 6080:80 \
        -p 5900:5900 \
        -v /proc:/host/:ro \
        -v /dev/shm:/dev/shm \
        -v /data/docker-data/ubuntu/:/volume/data \
        -e VNC_PASSWORD=vnc \
        dorowu/ubuntu-desktop-lxde-vnc
}

__AAA

__AAA1() {
    docker run -itd \
        --name=centos \
        --restart=always \
        --net=host \
        --privileged \
        -v /proc:/host/:ro \
        -v /dev/shm:/dev/shm \
        centos:7
}
__AAA1
