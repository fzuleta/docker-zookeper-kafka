# Docker with zookeeper and kafka
An example of running kafka (scalable to many kafkas) with zookeeper using docker, using enforced ssl and sasl.

## A note on ssl
do run ./createssl.sh to create new ssl certificates. note that the consumer and the server use the same keystore since it's been signed by a custom CA.

## To run the broker (zookeeper-kafka server):
1. docker-compose up

## To run the consumer
1. check the file `src/test/kotlin/kafka/kafkaTests.kt`
2. you can run it from intelliJ (make sure the broker is running) 

### Docker note:
note the tests have the bootstrap servers as **localhost** but the docker container name is kafka01, they are connected via the port being exposed to the host. if creating a container using a jar file, make sure to use the container name.

### This can be improved, this is the first working version I got using SASL_SSL and scalabla kafka brokers. feel free to work on this as well (actually that'd be great.)