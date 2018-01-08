SSL_STOREPASS=sslpass
SSL_KEYTOOL_SAN="SAN=DNS:localhost,DNS:kafka01,DNS:kafka02,DNS:kafka03,DNS:kafka04,DNS:kafka05"

SSL_ALIAS=localhost

SERVER_KEYSTORE_LOCATION=./ssl/server.keystore.jks
SERVER_TRUSTSTORE_LOCATION=./ssl/server.truststore.jks
CLIENT_TRUSTSTORE_LOCATION=./ssl/client.truststore.jks
CA_KEY=./ssl/ca-key
CA_CERT_FILE=./ssl/cert-file
CA_CERTFILE=./ssl/ca-cert
CA_CERTSIGNED=./ssl/cert-signed


keytool -noprompt -keystore ${SERVER_KEYSTORE_LOCATION} -storepass ${SSL_STOREPASS} -keypass ${SSL_STOREPASS} -alias ${SSL_ALIAS} -validity 3650 -keyalg RSA -genkey -ext "${SSL_KEYTOOL_SAN}" -dname "CN=${SSL_ALIAS}, OU=ID, O=example, L=example, S=example, C=GB"
openssl req -new -x509 -keyout ${CA_KEY} -nodes -out ${CA_CERTFILE} -days 3650 -subj "/C=GB/ST=London/L=London/O=Global Security/OU=IT Department/CN=${SSL_ALIAS}"
keytool -noprompt -keystore ${SERVER_TRUSTSTORE_LOCATION} -alias CARoot -import -file ${CA_CERTFILE} -storepass ${SSL_STOREPASS}
keytool -noprompt -keystore ${CLIENT_TRUSTSTORE_LOCATION} -alias CARoot -import -file ${CA_CERTFILE} -storepass ${SSL_STOREPASS}
keytool -noprompt -keystore ${SERVER_KEYSTORE_LOCATION} -alias ${SSL_ALIAS} -certreq -file ${CA_CERT_FILE} -storepass ${SSL_STOREPASS}
openssl x509 -req -CA ${CA_CERTFILE} -CAkey ${CA_KEY} -in ${CA_CERT_FILE} -out ${CA_CERTSIGNED} -days 3650 -CAcreateserial -passin pass:${SSL_STOREPASS}
keytool -noprompt -keystore ${SERVER_KEYSTORE_LOCATION} -alias CARoot -import -file ${CA_CERTFILE} -storepass ${SSL_STOREPASS}
keytool -noprompt -keystore ${SERVER_KEYSTORE_LOCATION} -alias ${SSL_ALIAS} -import -file ${CA_CERTSIGNED} -storepass ${SSL_STOREPASS}
