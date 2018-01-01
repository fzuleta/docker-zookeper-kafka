# Docker with zookeeper and kafka
An example of running kafka (scalable to many kafkas) with zookeeper using docker, using enforced ssl and sasl.

## A note on ssl
Kafka container's entrypoint, will create it's own set of self-signed certificates, on docker-compose you can change the password.
(it's convenient, but be sure to study your requirements)

### This can be improved, this is the first working version I got using SASL_SSL and scalabla kafka brokers. feel free to work on this as well (actually that'd be great.)