PORT=${PORT:-443}
TARGET_PORT=${TARGET_PORT:-80}

echo "Starting Proxy: $PORT"
echo "Target Docker Port: $TARGET_PORT"

cat nginx.conf.template | \
    sed "s|{{listenPort}}|$PORT|g" | \
    sed "s|{{targetPort}}|$TARGET_PORT|g" > /etc/nginx/nginx.conf

# Use exec so nginx can get signals directly
exec nginx
echo "Something Broke!"
