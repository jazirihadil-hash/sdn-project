FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends openvswitch-switch iproute2 iputils-ping && rm -rf /var/lib/apt/lists/*

# This tells Linux to write the script, so Windows cannot corrupt it
RUN echo '#!/bin/bash' > /start.sh && \
    echo 'service openvswitch-switch start' >> /start.sh && \
    echo 'sleep 2' >> /start.sh && \
    echo 'ovs-vsctl add-br br0' >> /start.sh && \
    echo 'ovs-vsctl set bridge br0 protocols=OpenFlow13' >> /start.sh && \
    echo 'ovs-vsctl set-controller br0 tcp:ryu-controller:6633' >> /start.sh && \
    echo 'sleep 3' >> /start.sh && \
    echo 'ovs-vsctl show' >> /start.sh && \
    echo 'tail -f /dev/null' >> /start.sh    chmod +x /start.sh

CMD ["bash", "/start.sh"]