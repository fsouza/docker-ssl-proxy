#!/bin/sh -e

DOMAIN=${DOMAIN:-www.example.com}
OUTPUT_DIR=/etc/nginx/certs

mkdir -p $OUTPUT_DIR

openssl genrsa -out ${OUTPUT_DIR}/key.pem 2048
openssl req -new -sha256 -key ${OUTPUT_DIR}/key.pem -nodes -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=${DOMAIN}" -out ${OUTPUT_DIR}/csr.pem
openssl x509 -req -in ${OUTPUT_DIR}/csr.pem -signkey ${OUTPUT_DIR}/key.pem -out ${OUTPUT_DIR}/cert.pem
