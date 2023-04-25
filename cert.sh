#!/usr/bin/env bash

set -x

SERVER_NAME="localhost"
SERVER_HOST="localhost"
SERVER_IP="127.0.0.1"

CLIENT_NAME="client"
CLIENT_HOST="localhost"
CLIENT_IP="127.0.0.1"

PROJ_DIR="`dirname \"$0\"`"
PROJ_DIR="`( cd \"$PROJ_DIR\" && pwd )`"

function deleteFile() {
  FILE_NAME="$1"

  if [ -f "${FILE_NAME}" ]; then
    rm "${FILE_NAME}"
  fi
}

# server keystore and cert ####################################################
# generate keystore for server

deleteFile "${SERVER_NAME}.p12"

keytool -genkeypair -v -alias server -storepass changeit -keyalg RSA -keysize 2048 -keystore $SERVER_NAME.p12 -storetype PKCS12 -validity 365 -ext SAN=dns:$SERVER_HOST,ip:$SERVER_IP << EOF
server
csm
gigaspaces
New York
NY
US
y
EOF

# export cert for server

deleteFile "${SERVER_NAME}.crt"

keytool -exportcert -v -alias server -file $SERVER_NAME.crt -keystore $SERVER_NAME.p12 -storepass changeit -storetype PKCS12


# client keystore and cert ####################################################
# generate keystore for client
deleteFile "${CLIENT_NAME}.p12"

keytool -genkeypair -v -alias client -storepass changeit -keyalg RSA -keysize 2048 -keystore $CLIENT_NAME.p12 -storetype PKCS12 -validity 365 -ext SAN=dns:$CLIENT_HOST,ip:$CLIENT_IP << EOF
client
csm
gigaspaces
New York
NY
US
y
EOF

# export cert for client

deleteFile "${CLIENT_NAME}.crt"

keytool -exportcert -v -alias client -file $CLIENT_NAME.crt -keystore $CLIENT_NAME.p12 -storepass changeit -storetype PKCS12

# import cert for client into server ##########################################

keytool -importcert -v -trustcacerts -alias client -file $CLIENT_NAME.crt -keystore $SERVER_NAME.p12 -storepass changeit -storetype PKCS12 -noprompt

# copy to maven project
cp "$SERVER_NAME.p12" $PROJ_DIR/src/main/resources/


# copy client cert
#deleteFile "${CLIENT_NAME}.crt"
#cp $CLIENT_NAME.cer $CLIENT_NAME.crt
