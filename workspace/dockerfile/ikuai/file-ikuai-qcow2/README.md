# 这个容器镜像是什么
PHP TP6

# 如何使用
## 与 vscode 配合使用
```bash
__run() {
    docker rm -f tp
    docker pull registry.cn-hangzhou.aliyuncs.com/lwmacct/php:thinkphp-v6.0.8-ls10
    docker run -itd --name tp \
        --restart=always \
        -p 80:80 \
        -v /data/docker-data/vscode/workspace/thinkphp:/apps/tp \
        registry.cn-hangzhou.aliyuncs.com/lwmacct/php:thinkphp-v6.0.8-ls10
}
__run
```
