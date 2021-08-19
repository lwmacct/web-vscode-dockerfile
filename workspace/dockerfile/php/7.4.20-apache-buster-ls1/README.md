# 这个容器镜像是什么
PHP 镜像, 修改版,添加了一些常用扩展

# 如何使用

## 与 vscode 配合使用
```bash
docker run -itd --name www \
    --restart=always \
    -p 80:80 \
    -v /data/docker-data/vscode/workspace/www:/var/www/html \
    registry.cn-hangzhou.aliyuncs.com/lwmacct/php:7.4.20-apache-buster-ls1
```

## 单独正常使用
```bash
docker run -itd --name www \
    --restart=always \
    -p 80:80 \
    -v /data/docker-data/www/:/var/www/html \
    registry.cn-hangzhou.aliyuncs.com/lwmacct/php:7.4.20-apache-buster-ls1
```
