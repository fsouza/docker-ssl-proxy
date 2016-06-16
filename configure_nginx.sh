#!/bin/sh -e

export PORT=${PORT:-443}
export TARGET_PORT=${TARGET_PORT:-80}
export TARGET_HOST=${TARGET_HOST:-proxyapp}

# Hack to avoid breaking nginx.conf
export host='$host' remote_addr='$remote_addr' proxy_add_x_forwarded_for='$proxy_add_x_forwarded_for' scheme='$scheme' remote_addr='$remote_addr'

echo "Starting Proxy: $PORT"
echo "Target Docker Port: $TARGET_PORT"

envsubst < /nginx.conf.template > /etc/nginx/nginx.conf

/add_self_signed_certs.sh

# Use exec so nginx can get signals directly
exec nginx
echo "Something Broke!"
