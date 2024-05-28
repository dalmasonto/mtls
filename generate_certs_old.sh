#!/bin/bash

# Remove ca dir if it exists
rm -rf ca

# Directory to store the generated certificates
CERT_DIR="ca"
mkdir -p ${CERT_DIR}

# CA key and certificate
openssl ecparam -name secp256r1 -genkey -noout -out ${CERT_DIR}/ca.key
openssl req -new -x509 -key ${CERT_DIR}/ca.key -out ${CERT_DIR}/ca.crt -days 365 -subj "/C=US/ST=State/L=City/O=Org/OU=OrgUnit/CN=Test CA"

# Server key and certificate signing request (CSR)
openssl ecparam -name secp256r1 -genkey -noout -out ${CERT_DIR}/localhost.key
openssl req -new -key ${CERT_DIR}/localhost.key -out ${CERT_DIR}/localhost.csr -subj "/C=US/ST=State/L=City/O=Org/OU=OrgUnit/CN=localhost"

# Sign the server CSR with the CA key
openssl x509 -req -in ${CERT_DIR}/localhost.csr -CA ${CERT_DIR}/ca.crt -CAkey ${CERT_DIR}/ca.key -CAcreateserial -out ${CERT_DIR}/localhost.crt -days 365
cat ${CERT_DIR}/localhost.crt ${CERT_DIR}/ca.crt > ${CERT_DIR}/localhost.bundle.crt

# Client key and certificate signing request (CSR)
openssl ecparam -name secp256r1 -genkey -noout -out ${CERT_DIR}/client.key
openssl req -new -key ${CERT_DIR}/client.key -out ${CERT_DIR}/client.csr -subj "/C=US/ST=State/L=City/O=Org/OU=OrgUnit/CN=client"

# Sign the client CSR with the CA key
openssl x509 -req -in ${CERT_DIR}/client.csr -CA ${CERT_DIR}/ca.crt -CAkey ${CERT_DIR}/ca.key -CAcreateserial -out ${CERT_DIR}/client.crt -days 365

# Convert client certificate and key to PEM format for reqwest
cat ${CERT_DIR}/client.crt ${CERT_DIR}/client.key > ${CERT_DIR}/client.pem

# Optional: Create a PKCS#12 bundle for the client
openssl pkcs12 -export -out ${CERT_DIR}/client.p12 -inkey ${CERT_DIR}/client.key -in ${CERT_DIR}/client.crt -certfile ${CERT_DIR}/ca.crt -password pass:1234

# Cleanup
# rm ${CERT_DIR}/*.csr
# rm ${CERT_DIR}/*.srl

echo "Certificates generated in the ${CERT_DIR} directory."

### Using RSA

# #!/bin/bash

# # Directory to store the generated certificates
# CERT_DIR="ca"
# mkdir -p ${CERT_DIR}

# # CA key and certificate
# openssl genpkey -algorithm RSA -out ${CERT_DIR}/ca.key
# openssl req -new -x509 -key ${CERT_DIR}/ca.key -out ${CERT_DIR}/ca.crt -days 365 -subj "/C=US/ST=State/L=City/O=Org/OU=OrgUnit/CN=Test CA"

# # Server key and certificate signing request (CSR)
# openssl genpkey -algorithm RSA -out ${CERT_DIR}/localhost.key
# openssl req -new -key ${CERT_DIR}/localhost.key -out ${CERT_DIR}/localhost.csr -subj "/C=US/ST=State/L=City/O=Org/OU=OrgUnit/CN=localhost"

# # Sign the server CSR with the CA key
# openssl x509 -req -in ${CERT_DIR}/localhost.csr -CA ${CERT_DIR}/ca.crt -CAkey ${CERT_DIR}/ca.key -CAcreateserial -out ${CERT_DIR}/localhost.crt -days 365
# cat ${CERT_DIR}/localhost.crt ${CERT_DIR}/ca.crt > ${CERT_DIR}/localhost.bundle.crt

# # Client key and certificate signing request (CSR)
# openssl genpkey -algorithm RSA -out ${CERT_DIR}/client.key
# openssl req -new -key ${CERT_DIR}/client.key -out ${CERT_DIR}/client.csr -subj "/C=US/ST=State/L=City/O=Org/OU=OrgUnit/CN=client"

# # Sign the client CSR with the CA key
# openssl x509 -req -in ${CERT_DIR}/client.csr -CA ${CERT_DIR}/ca.crt -CAkey ${CERT_DIR}/ca.key -CAcreateserial -out ${CERT_DIR}/client.crt -days 365

# # Convert client certificate and key to PEM format for reqwest
# cat ${CERT_DIR}/client.crt ${CERT_DIR}/client.key > ${CERT_DIR}/client.pem

# # Optional: Create a PKCS#12 bundle for the client
# openssl pkcs12 -export -out ${CERT_DIR}/client.p12 -inkey ${CERT_DIR}/client.key -in ${CERT_DIR}/client.crt -certfile ${CERT_DIR}/ca.crt -password "pass:1234"

# # Cleanup
# # rm ${CERT_DIR}/*.csr
# # rm ${CERT_DIR}/*.srl

# echo "Certificates generated in the ${CERT_DIR} directory."


### Convert to pkc#8 format
# #!/bin/bash

# # Directory to store the generated certificates
# CERT_DIR="ca"
# mkdir -p ${CERT_DIR}

# # CA key and certificate
# openssl genpkey -algorithm RSA -out ${CERT_DIR}/ca.key
# openssl req -new -x509 -key ${CERT_DIR}/ca.key -out ${CERT_DIR}/ca.crt -days 365 -subj "/C=US/ST=State/L=City/O=Org/OU=OrgUnit/CN=Test CA"

# # Server key and certificate signing request (CSR)
# openssl genpkey -algorithm RSA -out ${CERT_DIR}/localhost.key
# openssl req -new -key ${CERT_DIR}/localhost.key -out ${CERT_DIR}/localhost.csr -subj "/C=US/ST=State/L=City/O=Org/OU=OrgUnit/CN=localhost"

# # Sign the server CSR with the CA key
# openssl x509 -req -in ${CERT_DIR}/localhost.csr -CA ${CERT_DIR}/ca.crt -CAkey ${CERT_DIR}/ca.key -CAcreateserial -out ${CERT_DIR}/localhost.crt -days 365
# cat ${CERT_DIR}/localhost.crt ${CERT_DIR}/ca.crt > ${CERT_DIR}/localhost.bundle.crt

# # Client key and certificate signing request (CSR)
# openssl genpkey -algorithm RSA -out ${CERT_DIR}/client.key
# openssl req -new -key ${CERT_DIR}/client.key -out ${CERT_DIR}/client.csr -subj "/C=US/ST=State/L=City/O=Org/OU=OrgUnit/CN=client"

# # Sign the client CSR with the CA key
# openssl x509 -req -in ${CERT_DIR}/client.csr -CA ${CERT_DIR}/ca.crt -CAkey ${CERT_DIR}/ca.key -CAcreateserial -out ${CERT_DIR}/client.crt -days 365

# # Convert client certificate and key to PKCS#8 PEM format for reqwest
# openssl pkcs8 -topk8 -nocrypt -in ${CERT_DIR}/client.key -out ${CERT_DIR}/client.pkcs8.key
# cat ${CERT_DIR}/client.crt ${CERT_DIR}/client.pkcs8.key > ${CERT_DIR}/client.pem

# # Optional: Create a PKCS#12 bundle for the client
# openssl pkcs12 -export -out ${CERT_DIR}/client.p12 -inkey ${CERT_DIR}/client.key -in ${CERT_DIR}/client.crt -certfile ${CERT_DIR}/ca.crt -password pass:1234

# # Cleanup
# # rm ${CERT_DIR}/*.csr
# # rm ${CERT_DIR}/*.srl

# echo "Certificates generated in the ${CERT_DIR} directory."
