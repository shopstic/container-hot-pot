#!/usr/bin/dumb-init /bin/bash
set -euo pipefail

APP_DIR=$(dirname "$0")

dockerd-entrypoint.sh &

echo "Deleting prior volume snapshot if exists"
kubectl delete -n "${RELEASE_NAMESPACE}" volumesnapshot "${RELEASE_NAME}" || true

export DOCKER_HOST=unix:///var/run/docker.sock

until docker ps > /dev/null 2>&1; do
  echo "Wating for docker daemon..."
  sleep 1
done

mkdir /iac
curl \
  --header "PRIVATE-TOKEN: ${IAC_GITLAB_REPO_PRIVATE_TOKEN}" \
  -L "${IAC_GITLAB_REPO_ARCHIVE_URL}" |
  tar -xz --strip-components 1 -C /iac


kind create cluster "--config=${APP_DIR}/kind-cluster.yaml"
kubectl config use-context kind-kind
kubectl config set-context --current --namespace=default

cp /root/.kube/config /var/lib/docker/kind.conf
cp "${APP_DIR}/wait.sh" /var/lib/docker/wait.sh
chmod +x /var/lib/docker/wait.sh

#trap : TERM INT; sleep infinity & wait

echo "Installing..."
(cd /iac && "${APP_DIR}/install.sh")

docker stop kind-control-plane

kubectl config unset current-context

kubectl create -f - <<EOF
apiVersion: snapshot.storage.k8s.io/v1alpha1
kind: VolumeSnapshot
metadata:
  name: ${RELEASE_NAME}
  namespace: ${RELEASE_NAMESPACE}
spec:
  snapshotClassName: ${SNAPSHOT_CLASS_NAME}
  source:
    name: ${JOB_NAME}
    kind: PersistentVolumeClaim
EOF

#trap : TERM INT; sleep infinity & wait
