#!/usr/bin/env bash
_workspace=/tmp/docker_build
rm -rf $_workspace
mkdir -p $_workspace

# 写 Dockerfile 文件
cat >$_workspace/Dockerfile <<-'AEOF'
FROM php:7.4.20-apache-buster

ENV TZ=Asia/Shanghai
RUN rm -f /etc/localtime; \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list; \
    sed -i 's/security.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list; \
    apt-get clean; \
    apt-get update;

RUN apt-get -y install sudo; \
    sed '/root.ALL/a\www-data ALL=(ALL:ALL) NOPASSWD:ALL' -i /etc/sudoers

RUN apt-get install -y libwebp-dev libjpeg-dev libpng-dev libfreetype6-dev  libzip-dev libmcrypt-dev; \
    docker-php-ext-install bcmath pdo pdo_mysql zip gd exif sockets

RUN pecl install mcrypt redis; \
    docker-php-ext-enable mcrypt redis

AEOF

__build() {
    # 下面的参数  -t 参数,改成你自己的阿里云镜像服务仓库地址
    docker build -t registry.cn-hangzhou.aliyuncs.com/lwmacct/php:7.4.20-apache-buster-ls1 $_workspace
    docker push registry.cn-hangzhou.aliyuncs.com/lwmacct/php:7.4.20-apache-buster-ls1
}
__build

# 执行以下命令开始构建
__exec() {
    # 进入宿主机根进程空间(相当于宿主机命令行模式)
    nsenter --mount=/host/1/ns/mnt --net=/host/1/ns/net
    # 执行构建命令
    bash /data/docker-data/vscode/workspace/dockerfile/php/7.4.20-apache-buster-ls1/bulid.sh

    docker run --restart=always -itd -p 80:80 -v /data/docker-data/vscode/workspace/www:/var/www/html --name www registry.cn-hangzhou.aliyuncs.com/lwmacct/php:7.4.20-apache-buster-ls1
}

