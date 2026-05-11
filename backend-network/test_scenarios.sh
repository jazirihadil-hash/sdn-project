#!/bin/bash
# SDN Test Scenarios Script
set -e

SW1=switch-ovs-1

echo "=== Bronze: OVS-Ryu connectivity (br-int) ==="
docker exec $SW1 ovs-vsctl show
docker exec $SW1 ovs-ofctl -O OpenFlow13 dump-flows br-int | head -n 50

echo "=== Silver: VXLAN connectivity (h1 -> h3) ==="
docker exec $SW1 ip netns exec h1 ping -c 3 10.0.1.12

echo "=== Gold: Firewall ICMP block (h1 ping h2 should be blocked) ==="
# Ryu firewall app drops ICMP on PacketIn
if docker exec $SW1 ip netns exec h1 ping -c 3 -W 1 10.0.1.11 &>/dev/null; then
  echo "FAIL: ICMP passed"
else
  echo "OK: ICMP blocked"
fi

echo "=== Topology via REST (Ryu) ==="
curl -s http://localhost:8080/v1.0/topology/switches | head

echo "=== Flow table (br-int) ==="
docker exec $SW1 ovs-ofctl -O OpenFlow13 dump-flows br-int



