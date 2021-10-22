#!/bin/sh
set -e
seaf-cli init -d /seafile
exec seaf-daemon -c /root/.ccnet -d /seafile/seafile-data -w /seafile/libraries
