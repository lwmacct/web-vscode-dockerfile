# 这份代码库的作用是什么
   使用 WEB VsCode 便捷地构建 Docker 容器镜像  
   对应的语雀文档: https://www.yuque.com/uuu/docker/dockerfile-vscode

# 代码仓库地址 (同步)
   https://gitee.com/lwmacct/web-vscode-dockerfile  
   https://github.com/lwmacct/web-vscode-dockerfile  


# 如何使用这份代码?

在一台装有 Docker 和 Git 的 Linux 上按以下步骤操作  
主要是为了运行一个web vscode  
更多关于 web vscode https://www.yuque.com/uuu/vscode/web-vscode

1. 使用 Git 命令拉取到指定文件夹
   ```bash
    git clone https://gitee.com/lwmacct/web-vscode-dockerfile.git /data/docker-data/vscode
   ```
2. 使用 Docker 运行 web-vscode 
   ```bash
   __run_vscode() {
    docker rm -f vscode
    #rm -rf /data/docker-data/vscode
    docker pull registry.cn-hangzhou.aliyuncs.com/lwmacct/code-server:v3.9.3-ls78-base
    docker run -itd --name=vscode \
        --hostname=code \
        --restart=always \
        --privileged=true \
        --net=host \
        -e PASSWORD="" \
        -v /proc:/host \
        -v /data/docker-data/vscode:/config \
        registry.cn-hangzhou.aliyuncs.com/lwmacct/code-server:v3.9.3-ls78-base
    }
    __run_vscode
   ```
3. WEB 编辑器运行起来后查看当前设备IP,使用 8443 端口访问 http://youIP:8443
