#!/usr/bin/env bash
nohup socat TCP4-LISTEN:8825,reuseaddr,fork,su=root TCP4:192.168.9.254:80 >/dev/null 2>&1 &
