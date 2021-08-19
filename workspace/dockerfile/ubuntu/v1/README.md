# 这个容器镜像是什么
这是一个底包容器, 就如同你在使用 docker 构建一个应用时,你考虑使用 ubuntu 还是 debian  
而本笔者使用的是 ubuntu 添加了一些常规软件的镜像, 没错就是这个镜像
## 运行一个用于测试的 Ubuntu 
```bash
__run_ubuntu() {
    docker run -itd --name=ubuntu \
        --restart=always \
        --net=host \
        --privileged \
        -v /proc:/host/:ro \
        -v /data/docker-data/ubuntu/:/apps/mount \
        registry.cn-hangzhou.aliyuncs.com/lwmacct/ubuntu:v1
}
__run_ubuntu

```