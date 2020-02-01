#!/usr/bin/dumb-init /bin/bash
set -euo pipefail

mkdir -p /app/data/data /app/data/log

FDB_MACHINE_ID=${FDB_MACHINE_ID:-$(hostname)}
FDB_ZONE_ID=${FDB_ZONE_ID:-$(hostname)}
FDB_PUBLIC_IP=${FDB_PUBLIC_IP:-$(grep `hostname` /etc/hosts | sed -e "s/\s *`hostname`.*//")}

eval "cat <<EOF
$(<./base.conf)
EOF
" > ./fdb.conf

eval "cat <<EOF
$(<./app.conf)
EOF
" >> ./fdb.conf

/usr/lib/foundationdb/fdbmonitor --conffile=/app/fdb.conf --lockfile=/app/fdbmonitor.pid