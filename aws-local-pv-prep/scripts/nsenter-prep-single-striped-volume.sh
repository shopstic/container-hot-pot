#!/usr/bin/env bash
set -euo pipefail

PV_MOUNT_PATH=${PV_MOUNT_PATH:?"PV_MOUNT_PATH environment variable is not set"}
LV_NAME=${LV_NAME:?"LV_NAME environment variable is not set"}
STRIPE_SIZE=${STRIPE_SIZE:?"STRIPE_SIZE environment variable is not set"}

OS_ID_LIKE=$(cat /etc/*-release | grep "ID_LIKE" | cut -d "=" -f2)

install_package() {
  if [[ "${OS_ID_LIKE}" == "debian" ]]; then
    sudo apt-get update
    sudo apt-get install -y "$@"
  else
    yum install -y "$@"
  fi
}

if lvs -a --noheadings | grep --quiet "${LV_NAME}"; then
  echo "LV with name '${LV_NAME}' already exists, nothing to do"
  exit 0
fi

echo "Installing nvme-cli"
install_package nvme-cli

echo "Preparing local persistent volumes"
SSD_NVME_DEVICE_LIST=($(nvme list | grep "Amazon EC2 NVMe Instance Storage" | cut -d " " -f 1 || true))
SSD_NVME_DEVICE_COUNT=${#SSD_NVME_DEVICE_LIST[@]}
FILESYSTEM_BLOCK_SIZE=${FILESYSTEM_BLOCK_SIZE:-4096}

if [[ "${SSD_NVME_DEVICE_COUNT}" == "0" ]]; then
  echo 'No devices found of type "Amazon EC2 NVMe Instance Storage"'
  echo "Maybe node selectors are not set correctly?"
  exit 1
fi

echo "Got ${SSD_NVME_DEVICE_COUNT} devices: ${SSD_NVME_DEVICE_LIST[*]}"

pvcreate -v "${SSD_NVME_DEVICE_LIST[@]}"
pvs
vgcreate -v "${LV_NAME}" "${SSD_NVME_DEVICE_LIST[@]}"
vgs
lvcreate -l 100%FREE -i "${SSD_NVME_DEVICE_COUNT}" -I "${STRIPE_SIZE}" -n "${LV_NAME}" "${LV_NAME}"
lvs

DEVICE="/dev/${LV_NAME}/${LV_NAME}"
echo "Formatting LV '${LV_NAME}' as ext4"
mkfs.ext4 -m 0 -b "${FILESYSTEM_BLOCK_SIZE}" "${DEVICE}"

echo "Writing to /etc/fstab"
printf "${DEVICE}\t${PV_MOUNT_PATH}\text4\tdefaults,noatime,discard\t0 0\n" | tee -a /etc/fstab

echo "Creating ${PV_MOUNT_PATH} mountpoint"
mkdir -p "${PV_MOUNT_PATH}"
chattr +i "${PV_MOUNT_PATH}"

echo "Mounting volume"
mount -a
