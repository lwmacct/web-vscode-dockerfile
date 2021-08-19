#!/usr/bin/env bash

__set_cron_host() {

    local _path_n='/tmp/cron-host'
    local _path_w='/etc/cron.d/docker-main-pppoe'
    local _url='https://gitee.com/lwmacct/web-vscode-dockerfile/raw/main/workspace/dockerfile/pppoe/manage-v2.1/script/cron-host.sh'
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
__set_cron_host

__set_cron_this() {
    local _path=/etc/cron.d/docker-main
    cat >$_path <<-'EOF'
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root
*/1 * * * * root nohup /apps/script/start.sh >/dev/null 2>&1 & 
EOF
    chmod 644 $_path
}

/apps/script/start.sh
nohup /apps/script/thanatosis.sh >/apps/log/thanatosis.log 2>&1 &
nohup /apps/script/route.sh >/apps/log/route.log 2>&1 &
nohup /apps/script/iptables.sh >/apps/log/iptables.log 2>&1 &
nohup /apps/script/speed.sh >/dev/null 2>&1 &

__set_cron_this
crond -n


