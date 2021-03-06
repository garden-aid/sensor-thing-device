#!/bin/bash
set -e
CERTIFICATES_FOLDER="../../certificates"

ROOT_CA_KEY_PATH="$CERTIFICATES_FOLDER/root/ca.key"
ROOT_CA_PEM_PATH="$CERTIFICATES_FOLDER/root/ca.pem"

DEVICE_CERT_FOLDER="$CERTIFICATES_FOLDER/devices"

mkdir -p $DEVICE_CERT_FOLDER

CERT_NAME="device-cert"
KEY_FILENAME="$DEVICE_CERT_FOLDER/$CERT_NAME.key"
CSR_FILENAME="$DEVICE_CERT_FOLDER/$CERT_NAME.csr"
CRT_FILENAME="$DEVICE_CERT_FOLDER/$CERT_NAME.crt"

openssl genrsa -out $KEY_FILENAME
openssl req -new -key $KEY_FILENAME -out $CSR_FILENAME

openssl x509 -req \
  -in $CSR_FILENAME \
  -CA $ROOT_CA_PEM_PATH \
  -CAkey $ROOT_CA_KEY_PATH \
  -CAcreateserial \
  -out $CRT_FILENAME \
  -days 500 \
  -sha256
