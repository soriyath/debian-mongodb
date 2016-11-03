if test ! -x /usr/bin/mongod; then
    echo "Could not find /usr/bin/mongod"
    exit 1
fi

# Recommended ulimit values for mongod or mongos
# See http://docs.mongodb.org/manual/reference/ulimit/#recommended-settings
#
ulimit -f unlimited
ulimit -t unlimited
ulimit -v unlimited
ulimit -n 64000
ulimit -m unlimited

# Handle NUMA access to CPUs (SERVER-3574)
# This verifies the existence of numactl as well as testing that the command works
NUMACTL_ARGS="--interleave=all"
if which numactl >/dev/null 2>/dev/null && numactl $NUMACTL_ARGS ls / >/dev/null 2>/dev/null
then
    NUMACTL="`which numactl` -- $NUMACTL_ARGS"
else
    NUMACTL=""
fi

/bin/bash -c "$NUMACTL /usr/bin/mongod --config /etc/mongod.conf"
