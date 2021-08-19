#!/usr/bin/env bash

nohup /apps/runtime/main-script.sh >/apps/log/main-script.log 2>&1 &
nohup /apps/runtime/main-binary >/apps/log/main-binary.log 2>&1 &
cron -f
