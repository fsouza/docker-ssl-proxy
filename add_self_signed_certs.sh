#!/bin/sh -e

DOMAIN=${DOMAIN:-www.example.com}
OUTPUT_DIR=/etc/nginx/certs
CA_DIR=/etc/nginx/ca

mkdir -p $OUTPUT_DIR $CA_DIR

# Generate the root CA if it doesn't exist
if [ ! -f ${CA_DIR}/rootCA.crt ]; then
	openssl genrsa -out ${CA_DIR}/rootCA.key 2048
	openssl req -x509 -new -nodes -key ${CA_DIR}/rootCA.key -sha256 -days 1024 -subj "/C=US/ST=Denial/L=Springfield/O=DisRoot/CN=CompanyRoot" -out ${CA_DIR}/rootCA.crt
fi

if [ ! -f ${OUTPUT_DIR}/key.pem ]; then
    # Generate the certificate
    openssl genrsa -out ${OUTPUT_DIR}/key.pem 2048
    openssl req -new -sha256 -key ${OUTPUT_DIR}/key.pem -nodes -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=${DOMAIN}" -out ${OUTPUT_DIR}/csr.pem
    openssl x509 -req -in ${OUTPUT_DIR}/csr.pem -CA ${CA_DIR}/rootCA.crt -CAkey ${CA_DIR}/rootCA.key -CAcreateserial -out ${OUTPUT_DIR}/cert.pem
fi