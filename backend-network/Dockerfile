FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    openvswitch-switch \
    openvswitch-common \
    iproute2 \
    iputils-ping \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

# Use provided SDN init script (idempotent)
COPY init-sdn.sh /init-sdn.sh
RUN chmod +x /init-sdn.sh

CMD ["/init-sdn.sh"]
