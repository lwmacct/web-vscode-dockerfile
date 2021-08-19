# WEB VSCODE 在线编辑器

该镜像对应语雀文档  
<https://www.yuque.com/uuu/vscode/web-vscode>  
相关链接  
<https://github.com/linuxserver/docker-code-server/releases>  
<https://hub.docker.com/r/linuxserver/code-server>

# 以下代码内容仅仅备注该镜像的构建相关流程,使用该镜像需参考语雀文档

## 打包运行
```bash
nsenter --mount=/host/1/ns/mnt
```
```bash
__run_vscode() {
    docker rm -f vscode-bulid
    rm -rf /data/docker-data/vscode-bulid
    mkdir -p /data/docker-data/vscode-bulid/data
    echo '' >/data/docker-data/vscode-bulid/data/machineid
    docker pull registry.cn-hangzhou.aliyuncs.com/lwmacct/code-server:v3.11.1-ls89-base
    docker run -itd --name=vscode-bulid \
        --hostname=code \
        --restart=always \
        --privileged=true \
        -p 88:8443 \
        -e PASSWORD="" `#引号内可设置登录密码` \
        -v /proc:/host \
        -v /data/docker-data/vscode-bulid:/config \
        registry.cn-hangzhou.aliyuncs.com/lwmacct/code-server:v3.11.1-ls89-base
}
__run_vscode
```


## 安装插件
    Bracket Pair Colorizer
    Chinese (Simplified) Language Pack for Visual Studio Code
    Code Runner
    Increment Selection
    Markdown All in One
    Markdown Preview Enhanced
    One Dark Pro
    Shell launcher
    shell-format
    ShellCheck
    shellman
    vscode-icons


## vscode.tar.gz 配置打包过程
设置文件图标主题为 vscode-icons
设置颜色主题为 One Dark Pro

设置 Tree 间隔
    Tree: Indent 16

关闭扩展更新
    Update
    关掉选项

删除无用文件


安装drawio
https://marketplace.visualstudio.com/items?itemName=hediet.vscode-drawio

## 停止容器后删除无用文件
```bash

 nsenter --mount=/host/1/ns/mnt --net=/host/1/ns/net
docker kill   vscode-bulid

echo ''> /data/docker-data/vscode-bulid/.bash_history
rm -rf /data/docker-data/vscode-bulid/.config/code-server
rm -rf /data/docker-data/vscode-bulid/.local/share/code-server
rm -rf /data/docker-data/vscode-bulid/data/logs/*
rm -rf /data/docker-data/vscode-bulid/data/CachedExtensionVSIXs/*
rm -rf /data/docker-data/vscode-bulid/data/User/workspaceStorage/*
rm -rf /data/docker-data/vscode-bulid/data/User/state/*
rm -rf /data/docker-data/vscode-bulid/data/clp/*
rm -rf /data/docker-data/vscode-bulid/extensions/hediet.vscode-drawio-999.0.0-alpha/
```

## 跳转到目录进行 tar 打包
```bash
# 跳转并 tar 打包
cd /data/docker-data
tar zcvf vscode.tar.gz vscode-bulid/
# 复制打包好的文件到构建目录
cp -rf /data/docker-data/vscode.tar.gz  /data/docker-data/vscode/workspace/dockerfile/code-server/v3.11.1-ls89-base/res
```
 




