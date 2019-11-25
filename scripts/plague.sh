#!/bin/bash

################################################################################
# This script is meant to how simple it can be to cause noise on a system in
# order to distract from something real that might be going on. This script
# assumes that the container is allowed to run as root and has access to the
# host PID namespace.
#
# This script will generate a random number between 5 and 15 and wait that
# number of seconds before killing a given process. It will then generate
# another random number for which it wait that number of seconds before looking
# for the same process and killing it again. This will repeate in a while loop
# in perpetuity. The intended result is to cause instability of something
# easily accessible and relatively harmless, clutter logs and metrics so that
# the real target will hopefully go unnoticed.
################################################################################

PROCESS=$1

while true
do
  KILLWAIT=$(shuf -i 5-30 -n 1)

  if pgrep "$PROCESS" > /dev/null; then
    echo "waiting $KILLWAIT before killing $PROCESS"
    sleep "$KILLWAIT"
    echo "killing process $PROCESS"
    pkill "$PROCESS"
  else
    echo "process $PROCESS has not restarted yet, checking again in $KILLWAIT to kill again"
    sleep "$KILLWAIT"
  fi
done
