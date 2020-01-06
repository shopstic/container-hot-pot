#!/usr/bin/env bash
set -euo pipefail

export DOCKER_HOST=unix:///var/run/docker.sock

until docker ps > /dev/null 2>&1; do
  echo "Wating for docker daemon..."
  sleep 1
done

docker start kind-control-plane
mkdir ~/.kube
cp /var/lib/docker/kind.conf ~/.kube/config
kubectl config use-context kind-kind

exec /var/lib/docker/wait.sh
