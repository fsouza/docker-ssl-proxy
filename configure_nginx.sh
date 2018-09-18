#!/bin/sh -e

export TARGET_SCHEME=${TARGET_SCHEME:-http}
export TARGET_PORT=${TARGET_PORT:-80}
export TARGET_HOST=${TARGET_HOST:-proxyapp}
export CLIENT_MAX_BODY_SIZE=${CLIENT_MAX_BODY_SIZE:-20M}
export SSL_PORT=${SSL_PORT:-443}

REPLACEABLE='$TARGET_SCHEME:$TARGET_PORT:$TARGET_HOST:$CLIENT_MAX_BODY_SIZE:$SSL_PORT'

envsubst $REPLACEABLE < /nginx.conf.template > /etc/nginx/nginx.conf

/add_self_signed_certs.sh

# Use exec so nginx can get signals directly
exec nginx
