SDN Project – Software Defined Networking
Overview
Complete SDN infrastructure using Docker, Ryu Controller, Open vSwitch, and VXLAN.

Achievements
Level	Score	Status
Bronze	10/20	PASS - Controller connected
Silver	14/20	PASS - VXLAN connectivity working
Gold	18+/20	PASS - REST API + dynamic rules
Architecture
Ryu Controller (ports 6633, 8080)

switch-ovs-1 (172.20.0.10)
switch-ovs-2 (172.20.0.11)
Quick Start (After Reboot)
cd backend-network.\start-sdn.ps1

Verification Commands
Bronze - Check connection
docker exec switch-ovs-1 bash -c "export OVS_RUNDIR=/usr/local/var/run/openvswitch && ovs-vsctl show"

Silver - Ping test
docker exec switch-ovs-1 ping -c 4 172.20.0.11

Gold - API test
Invoke-RestMethod http://localhost:8080/v1.0/topology/switchesdocker exec switch-ovs-1 bash -c "ovs-ofctl dump-flows br-int"

Files
docker-compose.yml - Container orchestration
init-sdn.sh - OVS initialization
ryu_apps/firewall.py - Custom firewall app
start-sdn.ps1 - Post-reboot startup script
captures/*.pcap - Wireshark capture files