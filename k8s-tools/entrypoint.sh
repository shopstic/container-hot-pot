#!/usr/bin/dumb-init /bin/zsh
set -euo pipefail

REMOTE_SSH_CONFIG_PATH=${REMOTE_SSH_CONFIG_PATH:?"REMOTE_SSH_CONFIG_PATH env is not provided"}
REMOTE_SSH_USER=${REMOTE_SSH_USER:?"REMOTE_SSH_USER is not provided"}
REMOTE_SSH_PORT=${REMOTE_SSH_PORT:?"REMOTE_SSH_PORT is not provided"}
REMOTE_SSH_SHELL=${REMOTE_SSH_SHELL:?"REMOTE_SSH_SHELL is not provided"}

# powershell -NoLogo -Command -
ssh-keygen -q -b 4096 -t rsa -N '' -f /root/.ssh/id_rsa 2>/dev/null
ssh-keygen -q -b 4096 -t rsa -N '' -f /ssh/ssh_host_key 2>/dev/null
cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
cp /root/.ssh/id_rsa.pub /ssh/authorized_keys
cp /root/.ssh/id_rsa /ssh/id_rsa

echo "PermitRootLogin yes" >> /ssh/sshd_config
printf "AuthorizedKeysFile %s/authorized_keys\n" "${REMOTE_SSH_CONFIG_PATH}" >> /ssh/sshd_config
printf "PidFile %s/pid\n" "${REMOTE_SSH_CONFIG_PATH}" >> /ssh/sshd_config
echo "ListenAddress 127.0.0.1:${REMOTE_SSH_PORT}" >> /ssh/sshd_config
echo "LogLevel VERBOSE" >> /ssh/sshd_config

mkdir -p /run/sshd /etc/ssh
cp /ssh/ssh_host_key /etc/ssh/
echo "ListenAddress 0.0.0.0:22" >> /etc/ssh/sshd_config
echo "LogLevel VERBOSE" >> /etc/ssh/sshd_config

/usr/sbin/sshd -f /etc/ssh/sshd_config -E /root/sshd_log.txt || (cat /root/sshd_log.txt; exit 1)

cat << EOF >> /root/.zshrc
export HOST_EXEC="ssh -qt -o StrictHostKeyChecking=no -p 12222 ${REMOTE_SSH_USER}@localhost"
export HOST_SHELL="${REMOTE_SSH_SHELL}"
alias hostexec="ssh -qt -o StrictHostKeyChecking=no -p 12222 ${REMOTE_SSH_USER}@localhost"
minikube() {
  echo "minikube \$@" | ssh -qt -o StrictHostKeyChecking=no -p 12222 ${REMOTE_SSH_USER}@localhost ${REMOTE_SSH_SHELL}
}
EOF

touch /ssh/ready
zsh -l
