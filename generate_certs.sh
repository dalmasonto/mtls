#!/bin/bash

# Remove ca dir if it exists
rm -rf ca 

# Directory to store the generated certificates
CERT_DIR="ca"
mkdir -p ${CERT_DIR} && cd ${CERT_DIR}

# CA key and certificate
openssl genrsa -out ca.key 2048
openssl req -new -x509 -key ca.key -out ca.crt

# Server key and certificate 
openssl genrsa -out localhost.key 2048
# optional: inspect the key
openssl rsa -in localhost.key -noout -text
# optional: extract pubkey
openssl rsa -in localhost.key -pubout -out localhost.pubkey

# enter detailed information when necessary (please make sure you enter COMMON NAME)
openssl req -new -key localhost.key -addext "subjectAltName = DNS:localhost" -out localhost.csr
# optional: inspect the csr (note: while inspecting, make sure your Signature Algorithm is not MD5 which is not accepted by many sites, upgrade your openssl if necessary)
openssl req -in localhost.csr -noout -text

openssl x509 -req -in localhost.csr -CA ca.crt -CAkey ca.key -CAcreateserial -extfile <(printf "subjectAltName=DNS:localhost") -out localhost.crt
# optional: to exam the output crt
openssl x509 -in localhost.crt -noout -text
 
cat localhost.crt ca.crt > localhost.bundle.crt

# Client
echo "\n Generating client certificate \n"

openssl genrsa -out client_0.key 2048

# enter detailed information when necessary (please make sure you enter COMMON NAME)
openssl req -new -key client_0.key -addext "subjectAltName = DNS:localhost" -out client_0.csr

openssl x509 -req -in client_0.csr -CA ca.crt -CAkey ca.key -CAcreateserial -extfile <(printf "subjectAltName=DNS:localhost") -out client_0.crt

# generate pem file
cat client_0.crt client_0.key > client_0.pem
# optional: test command (after starting the server) using .pem file
# generate cert file to use with browser (setting password to be 123456 for example)
openssl pkcs12 -export -in client_0.pem -out client_0.p12 -name "client_0"
# optional: test command (after starting the server) using .p12 file

