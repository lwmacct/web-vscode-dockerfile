#!/usr/bin/env bash
_workspace=/tmp/docker_build
rm -rf $_workspace
mkdir -p $_workspace

# 写 Dockerfile 文件
cat >$_workspace/Dockerfile <<-'AEOF'
FROM registry.cn-hangzhou.aliyuncs.com/lwmacct/ubuntu:v1

# 安装依赖
RUN apt-get update && apt-get install -y socat iproute2

Add res/* /apps/
ENTRYPOINT ["/apps/entrypoint.sh"]
AEOF

__add_file() {
    mkdir -p $_workspace/res/
    cp -rf /data/docker-data/vscode/workspace/dockerfile/ikuai/centos-kvm-ls10/res $_workspace/res/
    chmod -R 777 $_workspace/res/
}
__add_file

__build() {
    # 下面的参数  -t 参数,改成你自己的阿里云镜像服务仓库地址
    docker build -t registry.cn-hangzhou.aliyuncs.com/lwmacct/ikuai:centos-kvm-ls10 $_workspace
    docker push registry.cn-hangzhou.aliyuncs.com/lwmacct/ikuai:centos-kvm-ls10
}
__build

# 执行以下命令开始构建
__exec() {
    # 进入宿主机根进程空间(相当于宿主机命令行模式)
    nsenter --mount=/host/1/ns/mnt --net=/host/1/ns/net
    # 执行构建命令
    bash /data/docker-data/vscode/workspace/dockerfile/ikuai/centos-kvm-ls10/bulid.sh

    docker rm -f kvm-ikuai-tools
    docker pull registry.cn-hangzhou.aliyuncs.com/lwmacct/ikuai:centos-kvm-ls10
    docker run --restart=always -itd --net=host --name kvm-ikuai-tools registry.cn-hangzhou.aliyuncs.com/lwmacct/ikuai:centos-kvm-ls10
    docker exec -it kvm-ikuai-tools bash
}
