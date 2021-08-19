#!/usr/bin/env bash

/apps/script/write-ifcfg.sh
nohup /apps/script/start-call.sh >/apps/log/start-call.log 2>&1 &
# nohup /apps/script/start-call.sh >/apps/log/start-call.log 2>&1 &

crond -n
