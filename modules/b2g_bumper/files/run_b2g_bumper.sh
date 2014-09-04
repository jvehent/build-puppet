#!/bin/bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# This file is managed by puppet
set -e
cd /builds/b2g_bumper
exec >> b2g_bumper.log 2>&1

function log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') pid-$$ $*"
}
log "Acquiring lock"
lockfile -s60 -r5 b2g_bumper.lock
trap "rm -f $PWD/b2g_bumper.lock" EXIT

export PATH=/usr/local/bin:$PATH

# Get mozharness updated / checked out and working
log "Updating mozharness"
timeout 300 /usr/local/bin/hgtool.py -b production https://hg.mozilla.org/build/mozharness mozharness

# Start the bumpers in parallel
pids=""
for config in master v2.1 v2.0 v1.4 v1.3 v1.3t; do
    log "Running b2g bumper ${config}, log in ${PWD}/${config}.log"
    if [ ! -d $config ]; then
        mkdir $config
    fi
    (cd $config; python ../mozharness/scripts/b2g_bumper.py -c b2g_bumper/${config}.py > ../$config.log 2>&1) &
    pids="$pids $!"
done

# Now wait for them to finish
retval=0
for pid in $pids; do
    wait $pid
    if [ $? != 0 ]; then
        retval=$?
    fi
done

if [ $retval = 0 ]; then
    # Touch our timestamp file so nagios can check if we're fresh
    touch b2g_bumper.stamp
    log "Done"
fi
