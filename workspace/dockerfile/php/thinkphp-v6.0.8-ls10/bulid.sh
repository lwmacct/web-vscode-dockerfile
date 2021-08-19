#!/usr/bin/env bash
_workspace=/tmp/docker_build
rm -rf $_workspace
mkdir -p $_workspace

# 写 Dockerfile 文件
cat >$_workspace/Dockerfile <<-'AEOF'
FROM registry.cn-hangzhou.aliyuncs.com/lwmacct/ubuntu:v1

# 安装依赖
RUN apt-get update && apt-get install -y composer php-pear php-dev php7.4-mysql  php-mbstring \
    libwebp-dev libjpeg-dev libpng-dev libfreetype6-dev  libzip-dev libmcrypt-dev;

# 安装tp6
RUN composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/; \
    mkdir -p /apps/ && cd /apps; \
    composer create-project topthink/think tp6;

# 安装扩展
RUN cd /apps/tp6/; \
    composer require \
    topthink/think-multi-app \
    topthink/think-view \
    topthink/think-captcha \
    topthink/think-helper \
    rediska/rediska \
    guzzlehttp/guzzle \
    mikehaertl/php-shellcommand

# 设置 PHP 最高权限
RUN apt-get -y install sudo; \
    sed '/root.ALL/a\www-data ALL=(ALL:ALL) NOPASSWD:ALL' -i /etc/sudoers

Add res/* /apps/
ENTRYPOINT ["/apps/entrypoint.sh"]
AEOF

__add_file() {
    mkdir -p $_workspace/res/
    cp -rf /data/docker-data/vscode/workspace/dockerfile/php/thinkphp-v6.0.8-ls10/res $_workspace/res/
    chmod -R 777 $_workspace/res/
}
__add_file

__build() {
    # 下面的参数  -t 参数,改成你自己的阿里云镜像服务仓库地址
    docker build -t registry.cn-hangzhou.aliyuncs.com/lwmacct/php:thinkphp-v6.0.8-ls10 $_workspace
    docker push registry.cn-hangzhou.aliyuncs.com/lwmacct/php:thinkphp-v6.0.8-ls10
}
__build

# 执行以下命令开始构建
__exec() {
    # 进入宿主机根进程空间(相当于宿主机命令行模式)
    nsenter --mount=/host/1/ns/mnt --net=/host/1/ns/net
    # 执行构建命令
    bash /data/docker-data/vscode/workspace/dockerfile/php/thinkphp-v6.0.8-ls10/bulid.sh

    docker run --restart=always -itd -p 80:80 -v /data/docker-data/vscode/workspace/www:/var/www/html --name www registry.cn-hangzhou.aliyuncs.com/lwmacct/php:thinkphp-v6.0.8-ls10
}
