#!/bin/bash
apt-get update && apt-get install -y openvswitch-common openvswitch-switch iproute2 iputils-ping
service openvswitch-switch start
ovs-vsctl add-br br0
ovs-vsctl set-controller br0 tcp:ryu-controller:6633
ovs-vsctl set bridge br0 protocols=OpenFlow13
bash
