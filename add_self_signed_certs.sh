mkdir /etc/nginx/certs/
cd /etc/nginx/certs/
openssl genrsa -out key.pem 2048
openssl req -new -sha256 -key key.pem -nodes -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" -out csr.pem
openssl x509 -req -in csr.pem -signkey key.pem -out cert.pem