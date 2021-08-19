ip link add link ens36.105 dev wan0 type macvlan mode private



ip link set wan0 up


ip link add link ens36 dev mac1 type macvlan mode bridge
ip link del link ens36 dev mac1 type macvlan mode bridge


ip link add link ens36.105 dev WAN4ffcf251096f type macvlan mode private
ip link set WAN4ffcf251096f up



ip link add link ens36 name ens36.106 type vlan id 106
ip link set ens36.106 up


ip link add link ens36.106 dev wan106 type macvlan mode private
ip link set wan106 up



ip link add link ens36 name ens36.107 type vlan id 107
ip link set ens36.107 up


ip link add link ens36.107 dev ens36.107.111 type macvlan mode private
ip link set wan106 up






ip link add link ens36.101 dev ens36.101.222 type macvlan mode private
ip link set ens36.101.222 up



ip link add link ens36.101 dev ens36.101.4c743c type macvlan mode private
ip link set ens36.101.4c743c968a08 up






ip link add link ens36 name ens36.107 type vlan id 107

ip link add link ens36.107 dev  ens36.107.111 type macvlan mode private

ip link set ens36.108 up


ip link add link ens36 name ens36.108 type vlan id 108
ip link set ens36.108  vf 0 mac 22:22:22:22:22:22


#echo $num_vf_enabled > /sys/class/net/$dev/device/sriov_numvfs #enable VFs
echo 1 > /sys/class/net/ens36/device/sriov_numvfs #disable VFs

4c743c968a08