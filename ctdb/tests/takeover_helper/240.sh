#!/bin/sh

. "${TEST_SCRIPTS_DIR}/unit.sh"

define_test "3 nodes, all ok, GET_PUBLIC_IPS timeout"

setup_ctdbd <<EOF
NODEMAP
0       192.168.20.41   0x0     CURRENT RECMASTER
1       192.168.20.42   0x0
2       192.168.20.43   0x0

IFACES
:Name:LinkStatus:References:
:eth2:1:2:
:eth1:1:4:

PUBLICIPS
10.0.0.31  1
10.0.0.32  1
10.0.0.33  1

CONTROLFAILS
90	2	TIMEOUT	CTDB_CONTROL_GET_PUBLIC_IPS fake timeout
EOF

required_result 110 <<EOF
control GET_PUBLIC_IPS failed on node 2, ret=110
Failed to fetch known public IPs
takeover run failed, ret=110
EOF
test_takeover_helper