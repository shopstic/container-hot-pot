#!/usr/bin/dumb-init /bin/bash
set -euo pipefail

cp /app/config.toml /etc/gitlab-runner/config.toml

cleanup() {
  gitlab-runner unregister --all-runners
}

trap "cleanup" EXIT

gitlab-runner register \
  --non-interactive \
  --template-config /app/template-config.toml \
  --url "${GITLAB_RUNNER_REGISTER_URL}" \
  --registration-token "${GITLAB_RUNNER_REGISTER_REGISTRATION_TOKEN}" \
  --name kind-runner \
  --executor custom \
  --builds-dir /builds \
  --cache-dir /cache \
  --shell bash \
  --custom-prepare-exec /app/prepare.sh \
  --custom-prepare-exec-timeout 300 \
  --custom-run-exec /app/run.sh \
  --custom-cleanup-exec /app/cleanup.sh \
  --custom-cleanup-exec-timeout 120 \
  --custom-graceful-kill-timeout 60 \
  --custom-force-kill-timeout 120

gitlab-runner run
