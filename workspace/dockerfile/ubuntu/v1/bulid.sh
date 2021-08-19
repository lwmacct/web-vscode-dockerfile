#!/usr/bin/env bash
exit 0
_workspace=/tmp/docker_build
rm -rf $_workspace
mkdir -p $_workspace

# 写 Dockerfile 文件
cat >$_workspace/Dockerfile <<-'AEOF'
FROM ubuntu:20.04

ENV TZ=Asia/Shanghai
RUN rm -f /etc/localtime; \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list; \
    sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list; \
    apt-get clean; \
    apt-get update;

# 安装常用软件包
RUN apt-get install -y sudo openssh-server iputils-ping net-tools curl  cron jq bc screen lrzsz  ncat zip unzip vim;

# 解开下行注释,添加 res 目录下的文件到容器内 /data 目录,底包镜像不建议添加文件,在构建应用的时候再添加,这里只是做示例
#ADD res/* /apps/

RUN apt-get clean; \
    rm -rf /var/lib/apt/lists/*; \
    rm -rf /etc/machine-id; \
    rm -rf /var/lib/dbus/machine-id; \
    echo root:lwmacct | chpasswd; \
    sed -i 's,^#PermitRootLogin.*$,PermitRootLogin yes,' /etc/ssh//sshd_config; \
    ln -s /usr/bin/python3 /usr/bin/python;

AEOF

__add_file() {
    mkdir -p $_workspace/res/
    cp -rf /data/docker-data/vscode/workspace/dockerfile/ubuntu/v1/res $_workspace/res/
    chmod -R 777 $_workspace/res/
}

__build() {
    # 下面的参数  -t 参数,改成你自己的阿里云镜像服务仓库地址
    docker build -t registry.cn-hangzhou.aliyuncs.com/lwmacct/ubuntu:v1 $_workspace
    docker push registry.cn-hangzhou.aliyuncs.com/lwmacct/ubuntu:v1
}
__add_file
__build

# 执行以下命令开始构建
__exec() {
    # 进入宿主机根进程空间(相当于宿主机命令行模式)
    nsenter --mount=/host/1/ns/mnt --net=/host/1/ns/net
    # 执行构建命令
    bash /data/docker-data/vscode/workspace/dockerfile/ubuntu/v1/bulid.sh
}
