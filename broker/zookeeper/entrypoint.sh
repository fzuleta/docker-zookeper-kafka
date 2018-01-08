#!/usr/bin/env bash

# MIT License

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# ENV File for config
JAVA_ENV_FILE=/opt/zookeeper/conf/java.env
if [ ! -e "${JAVA_ENV_FILE}" ]; then
  cat >"${JAVA_ENV_FILE}" <<EOF
export JVMFLAGS="-Djava.security.auth.login.config=/opt/jaas.conf"
EOF
fi



# SASL CONFIG
JAAS_CONF=/opt/jaas.conf
if [ ! -e "${JAAS_CONF}" ]; then
  cat >"${JAAS_CONF}" <<EOF
Server {
    org.apache.zookeeper.server.auth.DigestLoginModule required
    user_$ZOO_SERVER_USER="$ZOO_SERVER_PASSWORD";
};

EOF
fi



# ZOO CONFIG
ZOO_CONF_FILE=/opt/zookeeper/conf/zoo.cfg
if [ ! -e "${ZOO_CONF_FILE}" ]; then
  cat >"${ZOO_CONF_FILE}" <<EOF
tickTime=2000
dataDir=/zookeeper
clientPort=2181
initLimit=5
syncLimit=2

authProvider.0=org.apache.zookeeper.server.auth.DigestAuthenticationProvider

jaasLoginRenew=3600000
requireClientAuthScheme=sasl


EOF
fi


/opt/zookeeper/bin/zkServer.sh start-foreground