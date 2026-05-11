# SDN Project Fix TODO

## Completed (2/12)
1. [x] Refine init-sdn.sh: Fix br-int, add VXLAN port, create veth pairs (veth-h1, veth-h2, veth-h3), move peers to netns (ip netns add h1/h2/h3, ip link set veth-hX-peer netns hX), set IPs in netns (e.g., 10.0.1.10/24), attach veth-hX to br-int.
2. [x] Update Dockerfile: Copy init-sdn.sh, set ENTRYPOINT ["/init-sdn.sh"], remove /start.sh.

## In Progress

## Pending
12. [x] Update README.md with instructions.

All core files updated, tests ready. Run docker compose up --build -d && ./test_scenarios.sh manually.

