ip link add link ens36.105 dev wan0 type macvlan mode private



ip link set wan0 up


ip link add link ens36 dev mac1 type macvlan mode bridge
ip link del link ens36 dev mac1 type macvlan mode bridge


ip link add link ens36.105 dev WAN4ffcf251096f type macvlan mode private
ip link set WAN4ffcf251096f up