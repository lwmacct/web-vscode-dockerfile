#!/bin/bash
# 技术支持 QQ1713829947 http://lwm.icu
# exit 0
_work_space=/tmp/docker_build
rm -rf $_work_space
mkdir -p $_work_space

cat >$_work_space/Dockerfile <<-'AEOF'
FROM registry.cn-hangzhou.aliyuncs.com/lwmacct/ubuntu:v1

Add res/* /apps/
ENTRYPOINT ["/apps/entrypoint.sh"]
AEOF

mkdir -p $_work_space/res/
cp -rf /data/docker-data/vscode/workspace/dockerfile/ikuai/file-ikuai-qcow2/res $_work_space/res/
chmod -R 777 $_work_space/res/

__bulid() {
    docker build -t registry.cn-hangzhou.aliyuncs.com/lwmacct/ikuai:file-ikuai-qcow2 $_work_space # --no-cache
    docker push registry.cn-hangzhou.aliyuncs.com/lwmacct/ikuai:file-ikuai-qcow2
}
__bulid

__run() {

    nsenter --mount=/host/1/ns/mnt --net=/host/1/ns/net

    bash /data/docker-data/vscode/workspace/dockerfile/ikuai/file-ikuai-qcow2/bulid.sh
}

__help() {

    cat >/dev/null <<-AAAS
    运行参数参考以下文件


AAAS
    docker run -it --rm -v /data/kvm/machine/:/apps/mount/ registry.cn-hangzhou.aliyuncs.com/lwmacct/ikuai:file-ikuai-qcow2
}
