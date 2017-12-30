# Docker with zookeeper and kafka
An example of running kafka (scalable to many kafkas) with zookeeper using docker, using enforced ssl and sasl.

## Create SSL certificates and stores.
Make sure to run: `./ssl_create.sh` first. **Note the SSL Password `sslpass` on step 3.1: this is fed into docker-compose**

#### Note: I've left certificates in the folder for quick running, but PLEASE do **not** use it in prod. leaving it as is is a major vulnerability, you've been warned :) .


## This can be improved, this is the first working version I got using SASL_SSL and scalabla kafka brokers. feel free to work on this as well (actually that'd be great.)