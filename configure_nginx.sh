#!/bin/sh -e

export PORT=${PORT:-443}
export TARGET_PORT=${TARGET_PORT:-80}
export TARGET_HOST=${TARGET_HOST:-proxyapp}

echo "Starting Proxy: $PORT"
echo "Target Docker Port: $TARGET_PORT"

envsubst < /nginx.conf.template > /etc/nginx/nginx.conf

/add_self_signed_certs.sh

# Use exec so nginx can get signals directly
exec nginx
echo "Something Broke!"
