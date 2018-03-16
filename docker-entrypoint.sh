#!/bin/bash

set -e

if [[ "$#" == '0' ]]; then
    set -- npm start
fi

if [[ $1 == npm && "$(id -u)" = '0' ]]; then
    chown -R "$ZNOMP_USER:$ZNOMP_USER" "$ZNOMP_HOME"
    exec gosu "$ZNOMP_USER" "$BASH_SOURCE" "$@"
fi

exec "$@"