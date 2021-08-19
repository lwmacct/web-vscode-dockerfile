#!/usr/bin/env bash
_workspace=/tmp/docker_build
rm -rf $_workspace
mkdir -p $_workspace

# 写 Dockerfile 文件
cat >$_workspace/Dockerfile <<-'AEOF'
FROM registry.cn-hangzhou.aliyuncs.com/lwmacct/ubuntu:v1

# 安装常用软件包
RUN apt-get update && apt-get install -y python3-pip; \
    pip install webssh;

ADD res/* /apps
ENTRYPOINT ["/apps/entrypoint.sh"]
AEOF

__add_file() {
    mkdir -p $_workspace/res/
    cp -rf /data/docker-data/vscode/workspace/dockerfile/webssh/v1.5.3-ls1/res $_workspace/res/
    chmod -R 777 $_workspace/res/
}

__build() {
    # 下面的参数  -t 参数,改成你自己的阿里云镜像服务仓库地址
    docker build -t registry.cn-hangzhou.aliyuncs.com/lwmacct/webssh:v1.5.3-ls1 $_workspace
    docker push registry.cn-hangzhou.aliyuncs.com/lwmacct/webssh:v1.5.3-ls1
}
__add_file
__build

# 执行以下命令开始构建
__exec() {
    # 进入宿主机根进程空间(相当于宿主机命令行模式)
    nsenter --mount=/host/1/ns/mnt --net=/host/1/ns/net
    # 执行构建命令
    bash /data/docker-data/vscode/workspace/dockerfile/webssh/v1.5.3-ls1/bulid.sh
}
