#!/usr/bin/env bash
set -meuo pipefail

sysctl net.ipv4.ip_forward=1

TAILSCALE_HOSTNAME=${TAILSCALE_HOSTNAME:-"$(hostname)"}
TAILSCALE_AUTH_KEY=${TAILSCALE_AUTH_KEY:?"TAILSCALE_AUTH_KEY env variable is required"}
TAILSCALE_ADVERTISE_ROUTES=${TAILSCALE_ADVERTISE_ROUTES:?"TAILSCALE_ADVERTISE_ROUTES env variable is required"}

tailscaled &

TAILSCALE_BACKEND_STATE=""
until [[ "${TAILSCALE_BACKEND_STATE}" == "NeedsLogin" || "${TAILSCALE_BACKEND_STATE}" == "Running" ]]; do
  echo "Waiting for tailscaled, current state: ${TAILSCALE_BACKEND_STATE}"
  sleep 0.5
  TAILSCALE_BACKEND_STATE=$(tailscale status --json | jq -r .BackendState)
done

tailscale up --hostname "${TAILSCALE_HOSTNAME}" --authkey "${TAILSCALE_AUTH_KEY}" --advertise-routes "${TAILSCALE_ADVERTISE_ROUTES}"
wait
