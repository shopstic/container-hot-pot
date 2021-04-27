#!/usr/bin/dumb-init /bin/sh

MTU=$(cat /sys/class/net/eth0/mtu)
dockerd-entrypoint.sh --mtu "${MTU}" --network-control-plane-mtu "${MTU}" &

until test -e /var/run/docker.sock; do
  sleep 0.2
done

chmod 0666 /var/run/docker.sock
wait