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

FROM openjdk:latest

ARG ZOO_VERSION=3.4.11
RUN mkdir /opt/zookeeper-data &&\
    cd /

ENV ZOOKEEPER_VERSION=3.4.11
ENV ZOOKEEPER_HOME /opt/zookeeper

ADD entrypoint.sh /opt/entrypoint.sh

# -----
# to speed up you can download from http://apache.uniminuto.edu/zookeeper/zookeeper-3.4.11/zookeeper-3.4.11.tar.gz
# and place the folder inside the tar folder, also comment the wget on the next part.
# COPY tar/zookeeper.tar.gz /opt/

RUN cd /opt && \
    wget http://apache.uniminuto.edu/zookeeper/zookeeper-3.4.11/zookeeper-3.4.11.tar.gz -O zookeeper.tar.gz && \
    tar -xf zookeeper.tar.gz && \
    rm zookeeper.tar.gz && \
    mv /opt/zookeeper-$ZOOKEEPER_VERSION /opt/zookeeper && \
    chmod +x /opt/entrypoint.sh

VOLUME ["/opt/zookeeper-data"]

EXPOSE 2181 2888 3888

CMD ["/opt/entrypoint.sh"]