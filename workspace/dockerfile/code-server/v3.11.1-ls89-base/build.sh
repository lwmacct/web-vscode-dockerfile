#!/bin/bash
# exit 0
_workspace=/tmp/docker_build
rm -rf $_workspace
mkdir -p $_workspace

# 设置 Dockerfile
cat >$_workspace/Dockerfile <<-'AEOF'
FROM linuxserver/code-server:v3.11.1-ls89
USER root
ARG DEBIAN_FRONTEND=noninteractive
ENV PUID=1000 PGID=1000 TZ='Asia/Shanghai'
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list; \
    sed -i 's,^root:.*$,root:x:0:0:root:/config:/bin/bash,' /etc/passwd; \
    userdel -r abc; \
    useradd -o -u 0 -g 0 -M -d /config -s /bin/bash abc; \
    echo 'root:lwmacct' | chpasswd; \
    echo 'abc:lwmacct' | chpasswd;

RUN apt-get update; \
    apt-get install -y software-properties-common; \
    add-apt-repository --yes --update ppa:ansible/ansible; \
    apt-get install -y cron socat screen jq tree  git-lfs zip unzip lsof psmisc sshpass ansible bash-completion \
    build-essential  gcc   \
    iputils-ping net-tools iproute2 nfs-common telnet; \
    rm -rf /var/lib/apt/lists/*; \
    sed  -i 's,^#host_key_checking.*$,host_key_checking = Flse,' /etc/ansible/ansible.cfg;


ADD res/* /apps/
ENTRYPOINT ["/apps/entrypoint.sh"]
AEOF
# --no-cache

__add_file() {
    mkdir -p $_workspace/res/
    cp -rf /data/docker-data/vscode/workspace/dockerfile/code-server/v3.11.1-ls89-base/res $_workspace/res/
    chmod -R 777 $_workspace/res/
}

__build() {
    # 下面的参数  -t 参数,改成你自己的阿里云镜像服务仓库地址
    docker build -t registry.cn-hangzhou.aliyuncs.com/lwmacct/code-server:v3.11.1-ls89-base $_workspace
    docker push registry.cn-hangzhou.aliyuncs.com/lwmacct/code-server:v3.11.1-ls89-base
}

__add_file
__build

# 执行以下命令开始构建
__exec() {
    # 进入宿主机根进程空间(相当于宿主机命令行模式)
    nsenter --mount=/host/1/ns/mnt --net=/host/1/ns/net
    # 执行构建命令
    bash /data/docker-data/vscode/workspace/dockerfile/code-server/v3.11.1-ls89-base/build.sh
}
