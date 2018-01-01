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

ENV SCALA_VERSION=2.11
ENV KAFKA_VERSION=1.0.0
ENV KAFKA_HOME /opt/kafka

# -----
# to speed up you can download from http://apache.uvigo.es/kafka/1.0.0/kafka_2.11-1.0.0.tgz
# and place the folder inside the tar folder, also comment the wget on the next part.

COPY tar/kafka.tar.gz /opt/

RUN cd /opt && \
    # wget http://apache.uvigo.es/kafka/$KAFKA_VERSION/kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz -O kafka.tar.gz && \
    tar -xf kafka.tar.gz && \
    rm kafka.tar.gz && \
    mv /opt/kafka_$SCALA_VERSION-$KAFKA_VERSION /opt/kafka

ADD entrypoint.sh /opt/entrypoint.sh

RUN chmod +x /opt/entrypoint.sh

EXPOSE 9092 9093

CMD ["/opt/entrypoint.sh"]