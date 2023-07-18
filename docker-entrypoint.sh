#!/bin/sh
set -e

# Clean up existing server.pid. Sometimes Rails doesn't shut down cleanly
# and this file needs to be removed manually to start a new server.
if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

# Replace this running Bash script with a Rails server
exec "$@"
