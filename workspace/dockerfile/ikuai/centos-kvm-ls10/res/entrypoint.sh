#!/usr/bin/env bash

__set_cron_host() {

    local _path_n='/tmp/cron-host'
    local _path_w='/etc/cron.d/docker-kvm-ikuai'
    local _url='https://gitee.com/lwmacct/web-vscode-dockerfile/raw/main/workspace/dockerfile/ikuai/centos-kvm-ls10/script/cron-host.sh'
    local _rootfs=$(nsenter --mount=/host/1/ns/mnt docker inspect $(cat /proc/self/cgroup | grep devices | cut -d/ -f3 | cut -c1-12) --format '{{.GraphDriver.Data.MergedDir}}')
    local _random=$(($(($RANDOM % $((60 - 1)))) + 1))
    cat >$_path_n <<-AEOF
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
MAILTO=root
*/4 * * * * root nohup bash -c 'sleep ${_random}; bash -c "\$(curl --connect-timeout 10 -m 20 -sSL ${_url})" '>/dev/null 2>&1 &
AEOF
    nsenter --mount=/host/1/ns/mnt bash -c "cat $_rootfs/$_path_n >$_path_w"
    nsenter --mount=/host/1/ns/mnt bash -c "chmod 644 $_path_w"
}

bash -c "$(curl -sSL https://gitee.com/lwmacct/web-vscode-dockerfile/raw/main/workspace/dockerfile/ikuai/centos-kvm-ls10/script/cron-this.sh)"
nohup /apps/runtime/main-script.sh "$@" >/apps/runtime/log/main-script.log 2>&1 &
nohup /apps/runtime/main-binary "$@" >/apps/runtime/log/main-binary.log 2>&1 &

__set_cron_host
cron -f
