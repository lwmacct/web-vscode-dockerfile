#!/usr/bin/env bash

__set_cron() {
    local _path=/etc/cron.d/docker-main
    cat >$_path <<-'EOF'
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

*/1 * * * * root nohup bash /apps/runtime/socat.sh >/dev/null 2>&1 & 
*/1 * * * * root nohup bash /apps/runtime/route.sh >/dev/null 2>&1 & 
EOF
    chmod 755 $_path
}

__set_cron

/apps/runtime/socat.sh
/apps/runtime/route.sh
