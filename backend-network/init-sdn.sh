#!/bin/bash
set -e

# Idempotent OVS install
if ! dpkg -l | grep -q openvswitch-switch; then
apt-get update && apt-get install -y openvswitch-switch iproute2 iputils-ping
fi

service openvswitch-switch start || true
sleep 2

# Create integration bridge
ovs-vsctl --if-exists del-br br-int || true
ovs-vsctl add-br br-int
ovs-vsctl set bridge br-int protocols=OpenFlow13
ovs-vsctl set-controller br-int tcp:ryu-controller:6633

# Ensure bridge is up
ip link set br-int up || true

# Add VXLAN port (overlay to other switch)
REMOTE_IP=${REMOTE_IP:-172.20.0.11}
ovs-vsctl --may-exist add-port br-int vxlan0 -- \
  set Interface vxlan0 type=vxlan options:remote_ip=$REMOTE_IP options:key=flow options:local_ip=flow

# Hosts placement:
# - switch-ovs-1: h1, h2
# - switch-ovs-2: h3
HOSTS="h1 h2"
if [[ "$(hostname)" == *"switch-ovs-2"* ]]; then
  HOSTS="h3"
fi

for H in $HOSTS; do
  # h1 -> i=1, h2 -> i=2, etc.
  i=${H#h}
  NS=$H
  VETH=veth-$H

  ip netns add $NS 2>/dev/null || true
  ip link add $VETH type veth peer name ${VETH}-peer 2>/dev/null || ip link delete $VETH
  ip link set ${VETH}-peer netns $NS

  ip netns exec $NS ip addr flush dev ${VETH}-peer
  ip netns exec $NS ip addr add 10.0.1.$i/24 dev ${VETH}-peer
  ip netns exec $NS ip link set ${VETH}-peer up

  ip link set $VETH up
  ovs-vsctl --may-exist add-port br-int $VETH
done

echo "SDN node init complete on $(hostname). br-int up, hosts: $HOSTS"
echo "Check OVS: ovs-vsctl show"

# Keep container alive
exec tail -f /dev/null


