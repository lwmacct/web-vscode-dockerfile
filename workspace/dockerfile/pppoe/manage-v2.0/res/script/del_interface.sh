#!/usr/bin/env bash
# 删除无效的 Vlan 文件

__mian() {
    _rootfs=$(nsenter --mount=/host/1/ns/mnt docker inspect $(cat /proc/self/cgroup | grep devices | cut -d/ -f3 | cut -c1-12) | jq -r ".[0].GraphDriver.Data.MergedDir")
    cat >/tmp/del_interface.sh <<-'AEOF'
ifconfig | grep 'TX packets 0  bytes 0 (0.0 B)' -B3 | grep -E '\.[0-9]{1,3}:\s' | awk -F ':' '{print "ifdown "$1"; rm -rf /etc/sysconfig/network-scripts/ifcfg-" $1}' | bash
AEOF
    nsenter --mount=/host/1/ns/mnt bash "$_rootfs"/tmp/del_interface.sh

}
__mian
