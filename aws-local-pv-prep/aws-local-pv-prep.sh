#!/usr/bin/dumb-init /bin/bash
set -euo pipefail

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

for DEVICE in "${SSD_NVME_DEVICE_LIST[@]}"
do
  echo "-------------------------------------------"
  echo "Checking ${DEVICE} for existing filesystem"

  if blkid -s UUID -o value "${DEVICE}"; then
    echo "Device was already formatted, skipping: ${DEVICE}"
  else
    echo "Formatting ${DEVICE}"
    mkfs.ext4 -m 0 -b "${FILESYSTEM_BLOCK_SIZE}" "${DEVICE}"
    UUID=$(blkid -s UUID -o value "${DEVICE}")
    mkdir -p "/pv-disks/${UUID}"
    chattr +i "/pv-disks/${UUID}"
    printf "UUID=${UUID}\t/pv-disks/${UUID}\text4\tdefaults,noatime,discard\t0 0\n" | tee -a /etc/fstab
  fi
done

echo "Mounting all volumes"
mount -a
echo "All done!"
sleep infinity