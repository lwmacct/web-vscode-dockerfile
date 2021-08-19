# 这个容器镜像是什么
web ssh
https://github.com/huashengdun/webssh
## 运行一个用于测试的 Ubuntu 
```bash
nsenter --mount=/host/1/ns/mnt --net=/host/1/ns/net
__run_webssh() {
    docker rm -f wssh
    docker pull registry.cn-hangzhou.aliyuncs.com/lwmacct/webssh:v1.5.3-ls1
    docker run -itd --name=wssh \
        --restart=always \
        -p 8888:8888 \
        --link frp:frp \
        registry.cn-hangzhou.aliyuncs.com/lwmacct/webssh:v1.5.3-ls1
}
__run_webssh
```