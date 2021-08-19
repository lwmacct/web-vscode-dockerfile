#!/usr/bin/env bash

# 如果没有文件则复制原始tp文件
__init() {
    if [ ! -f "/apps/tp/think" ]; then
        mkdir -p /apps/tp/
        cp -arf /apps/tp6/. /apps/tp/
    fi
}
__init

cd /apps/tp && php think run -p 80
