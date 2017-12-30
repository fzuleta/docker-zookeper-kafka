#!/bin/bash
# this set of commands, follows instructions at
# https://docs.confluent.io/2.0.0/kafka/ssl.html

#Step 1
keytool -keystore server.keystore.jks -alias localhost -validity 365 -keyalg RSA -genkey -ext "SAN=DNS:localhost,DNS:zookeeper,DNS:kafka01,DNS:kafka02,DNS:kafka03,DNS:kafka04,DNS:kafka05"

#Step 2
openssl req -new -x509 -keyout ca-key -out ca-cert -days 365
keytool -keystore server.truststore.jks -alias CARoot -import -file ca-cert
keytool -keystore client.truststore.jks -alias CARoot -import -file ca-cert

#Step 3
keytool -keystore server.keystore.jks -alias localhost -certreq -file cert-file

#Step 3.1 replace sslpass with your strong password
openssl x509 -req -CA ca-cert -CAkey ca-key -in cert-file -out cert-signed -days 365 -CAcreateserial -passin pass:sslpass

keytool -keystore server.keystore.jks -alias CARoot -import -file ca-cert
keytool -keystore server.keystore.jks -alias localhost -import -file cert-signed