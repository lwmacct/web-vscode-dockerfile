#!/usr/bin/env bash

__int2() {
    mkdir -p /data/docker-data/pppoe/
    cat >/data/docker-data/pppoe/account.txt <<-'AEOF'
101    1001    pwd      ens36
102    1002    pwd      ens36
AEOF
    cat /data/docker-data/pppoe/account.txt
}
__int2

__int5() {
    mkdir -p /data/docker-data/pppoe/
    cat >/data/docker-data/pppoe/account.txt <<-'AEOF'
101     1001    pwd     ens36
102     1002    pwd     ens36
103     1003    pwd     ens36
104     1004    pwd     ens36
105     1005    pwd     ens36
AEOF
    cat /data/docker-data/pppoe/account.txt
}
__int5

__int30() {
    mkdir -p /data/docker-data/pppoe/
    cat >/data/docker-data/pppoe/account.txt <<-'AEOF'
101     1001    pwd     ens36
102     1002    pwd     ens36
103     1003    pwd     ens36
104     1004    pwd     ens36
105     1005    pwd     ens36
106     1006    pwd     ens36
107     1007    pwd     ens36
108     1008    pwd     ens36
109     1009    pwd     ens36
110     1010    pwd     ens36
111     1011    pwd     ens36
112     1012    pwd     ens36
113     1013    pwd     ens36
114     1014    pwd     ens36
115     1015    pwd     ens36
116     1016    pwd     ens36
117     1017    pwd     ens36
118     1018    pwd     ens36
119     1019    pwd     ens36
120     1020    pwd     ens36
121     1021    pwd     ens36
122     1022    pwd     ens36
123     1023    pwd     ens36
124     1024    pwd     ens36
125     1025    pwd     ens36
126     1026    pwd     ens36
127     1027    pwd     ens36
128     1028    pwd     ens36
129     1029    pwd     ens36
130     1030    pwd     ens36
AEOF
    cat /data/docker-data/pppoe/account.txt
}
__int30

docker exec -it call-manage bash

for a in {1..100}; do
    ip rule del lookup m201
done

10.18.39.1

ip a | grep -Eo 'ppp[0-9]{1,2}$' | grep -Eo '[0-9]{1,2}' | sort -n


ip r | grep -v 'ppp' | grep -v "$(ls /sys/devices/virtual/net/)" | grep 'src'