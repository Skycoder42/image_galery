#!/bin/bash
set -em

seaf-cli init -d /seafile
seaf-daemon -c /root/.ccnet -d /seafile/seafile-data -w /seafile/libraries &
sleep 5

if ! seaf-cli list | grep "$LIBRARY"; then
  if [ "$LIBPASSWD" != "" ]; then
    LIBPASSWD_ARGS="-e $LIBPASSWD"
  fi
  seaf-cli download \
    -l "$LIBRARY" \
    -s "$SERVER" \
    -d "/seafile/libraries" \
    -u "$USERNAME" \
    -p "$PASSWORD" \
    $LIBPASSWD_ARGS
fi

exec fg
