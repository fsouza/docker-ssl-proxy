rm -r certs
mkdir certs
openssl genrsa -out certs/key.pem 2048
openssl req -new -sha256 -key certs/key.pem -out certs/csr.pem
openssl x509 -req -in certs/csr.pem -signkey certs/key.pem -out certs/cert.pem