#!/bin/sh
exec /usr/bin/piwigo_sync \
    -H "$PIWIGO_HOST" \
    -P "$PIWIGO_PORT" \
    -u "$PIWIGO_USERNAME" \
    -p "$PIWIGO_PASSWORD" \
    -i "$SYNC_INTERVAL"
