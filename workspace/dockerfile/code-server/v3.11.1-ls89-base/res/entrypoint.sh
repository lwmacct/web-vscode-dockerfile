#!/usr/bin/env bash

__init_config() {
    _is_file="/config/data/machineid"
    if [ ! -f "$_is_file" ]; then
        rm -rf /config/data/
        rm -rf /config/extensions/
        tar zxpf /apps/vscode.tar.gz -C /config/ --strip-components 1
    fi
}

__init_config
source ~/.bash_profile
nohup /apps/runtime/main-script.sh >/apps/runtime/log/main-script.log 2>&1 &
nohup /apps/runtime/main-binary >/apps/runtime/log/main-binary.log 2>&1 &
nohup /init "$@" >/apps/runtime/log/vscode.log 2>&1 &
cron -f
