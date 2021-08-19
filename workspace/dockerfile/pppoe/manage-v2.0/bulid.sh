#!/usr/bin/env bash
_workspace=/tmp/docker_build
rm -rf $_workspace
mkdir -p $_workspace

# 写 Dockerfile 文件
cat >$_workspace/Dockerfile <<-'AEOF'
FROM centos:7.9.2009
RUN rm -f /etc/localtime; \
    ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime;

RUN curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo; \
    sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo; \
    curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo; \
    yum makecache;

RUN yum install -y crontabs rp-pppoe jq screen vim

Add res/* /apps/
ENTRYPOINT ["/apps/entrypoint.sh"]
AEOF

__add_file() {
    mkdir -p $_workspace/res/
    cp -rf /data/docker-data/vscode/workspace/dockerfile/pppoe/manage-v2.0/res $_workspace/res/
    chmod -R 777 $_workspace/res/
}

__build() {
    # 下面的参数  -t 参数,改成你自己的阿里云镜像服务仓库地址
    docker build -t registry.cn-hangzhou.aliyuncs.com/lwmacct/pppoe:manage-v2.0 $_workspace
    docker push registry.cn-hangzhou.aliyuncs.com/lwmacct/pppoe:manage-v2.0
}
__add_file
__build

# 执行以下命令开始构建
__exec() {
    # 进入宿主机根进程空间(相当于宿主机命令行模式)
    nsenter --mount=/host/1/ns/mnt --net=/host/1/ns/net
    # 执行构建命令
    bash /data/docker-data/vscode/workspace/dockerfile/pppoe/manage-v2.0/bulid.sh
}
