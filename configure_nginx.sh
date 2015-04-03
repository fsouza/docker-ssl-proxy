echo "Starting Proxy: $PORT"
cat nginx.conf.template | sed "s|{{listenPort}}|$PORT|g" > /etc/nginx/nginx.conf
service nginx start
echo "Something Broke!"