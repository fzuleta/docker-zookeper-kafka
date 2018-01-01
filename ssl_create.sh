#!/bin/bash
# this set of commands, follows instructions at
# https://docs.confluent.io/2.0.0/kafka/ssl.html

KEYPASS=mykeypass
STOREPASS=mystorepass
SSL_KEYTOOL_SAN="SAN=DNS:localhost,DNS:zookeeper,DNS:kafka01,DNS:kafka02,DNS:kafka03,DNS:kafka04,DNS:kafka05"

#Step 1
keytool -noprompt -keystore server.keystore.jks -storepass ${STOREPASS} -keypass ${KEYPASS} -alias localhost -validity 3650 -keyalg RSA -genkey -ext ${SSL_KEYTOOL_SAN} -dname "CN=localhost, OU=ID, O=example, L=example, S=example, C=GB" 

#Step 2
openssl req -new -x509 -keyout ca-key -nodes -out ca-cert -days 3650 -subj "/C=GB/ST=London/L=London/O=Global Security/OU=IT Department/CN=localhost"
keytool -noprompt -keystore server.truststore.jks -alias CARoot -import -file ca-cert -storepass ${STOREPASS}
keytool -noprompt -keystore client.truststore.jks -alias CARoot -import -file ca-cert -storepass ${STOREPASS}

#Step 3
keytool -noprompt -keystore server.keystore.jks -alias localhost -certreq -file cert-file -storepass ${STOREPASS}


openssl x509 -req -CA ca-cert -CAkey ca-key -in cert-file -out cert-signed -days 3650 -CAcreateserial -passin pass:${KEYPASS}

keytool -noprompt -keystore server.keystore.jks -alias CARoot -import -file ca-cert -storepass ${STOREPASS}
keytool -noprompt -keystore server.keystore.jks -alias localhost -import -file cert-signed -storepass ${STOREPASS}