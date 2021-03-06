Usage: ip link add [link DEV] [ name ] NAME
                   [ txqueuelen PACKETS ]
                   [ address LLADDR ]
                   [ broadcast LLADDR ]
                   [ mtu MTU ] [index IDX ]
                   [ numtxqueues QUEUE_COUNT ]
                   [ numrxqueues QUEUE_COUNT ]
                   type TYPE [ ARGS ]

       ip link delete { DEVICE | dev DEVICE | group DEVGROUP } type TYPE [ ARGS ]

       ip link set { DEVICE | dev DEVICE | group DEVGROUP }
	                  [ { up | down } ]
	                  [ type TYPE ARGS ]
	                  [ arp { on | off } ]
	                  [ dynamic { on | off } ]
	                  [ multicast { on | off } ]
	                  [ allmulticast { on | off } ]
	                  [ promisc { on | off } ]
	                  [ trailers { on | off } ]
	                  [ carrier { on | off } ]
	                  [ txqueuelen PACKETS ]
	                  [ name NEWNAME ]
	                  [ address LLADDR ]
	                  [ broadcast LLADDR ]
	                  [ mtu MTU ]
	                  [ netns { PID | NAME } ]
	                  [ link-netnsid ID ]
			  [ alias NAME ]
	                  [ vf NUM [ mac LLADDR ]
				   [ vlan VLANID [ qos VLAN-QOS ] [ proto VLAN-PROTO ] ]
				   [ rate TXRATE ]
				   [ max_tx_rate TXRATE ]
				   [ min_tx_rate TXRATE ]
				   [ spoofchk { on | off} ]
				   [ query_rss { on | off} ]
				   [ state { auto | enable | disable} ] ]
				   [ trust { on | off} ] ]
				   [ node_guid { eui64 } ]
				   [ port_guid { eui64 } ]
			  [ xdp { off |
				  object FILE [ section NAME ] [ verbose ] |
				  pinned FILE } ]
			  [ master DEVICE ][ vrf NAME ]
			  [ nomaster ]
			  [ addrgenmode { eui64 | none | stable_secret | random } ]
	                  [ protodown { on | off } ]

       ip link show [ DEVICE | group GROUP ] [up] [master DEV] [vrf NAME] [type TYPE]

       ip link xstats type TYPE [ ARGS ]

       ip link afstats [ dev DEVICE ]

       ip link help [ TYPE ]

TYPE := { vlan | veth | vcan | dummy | ifb | macvlan | macvtap |
          bridge | bond | team | ipoib | ip6tnl | ipip | sit | vxlan |
          gre | gretap | ip6gre | ip6gretap | vti | nlmon | team_slave |
          bond_slave | ipvlan | geneve | bridge_slave | vrf | macsec }
