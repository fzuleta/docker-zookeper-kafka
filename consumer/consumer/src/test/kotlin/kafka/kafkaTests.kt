package kafka

import com.google.gson.*
import org.apache.commons.io.FileUtils
import org.apache.kafka.clients.consumer.ConsumerConfig
import org.apache.kafka.clients.consumer.KafkaConsumer
import org.apache.kafka.clients.producer.KafkaProducer
import org.apache.kafka.clients.producer.ProducerConfig
import org.apache.kafka.clients.producer.ProducerRecord
import org.junit.Assert
import org.junit.Ignore
import org.junit.Test
import java.util.*

fun JsonObject.primitive(s:String): JsonElement? {
    if (has(s) && !get(s).isJsonNull) return get(s)
    return null
}
fun JsonObject.s(s:String): String? = primitive(s)?.asString


class kafkaTests {
    companion object {
        val gson: Gson = GsonBuilder().setPrettyPrinting().disableHtmlEscaping().create()
        val topic = "helloFromTest"
    }
    @Test
    fun `can make a producer`() {
        val LOCAL_FOLDER_LOCATION = FileUtils.getFile("").absolutePath.split("consumer")[0]
        println(LOCAL_FOLDER_LOCATION)
        System.setProperty("java.security.auth.login.config", "${LOCAL_FOLDER_LOCATION}consumer/consumer/src/main/resources/kafka_jaas.conf")
        var error = false
        val prodProps = Properties()
        prodProps.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, "localhost:9092")
        prodProps.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, "org.apache.kafka.common.serialization.StringSerializer")
        prodProps.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, "org.apache.kafka.common.serialization.StringSerializer")
        prodProps.put(ProducerConfig.CLIENT_ID_CONFIG, "mykafkaclientid2")

        prodProps.put("ssl.truststore.location", "${LOCAL_FOLDER_LOCATION}ssl/client.truststore.jks")
        prodProps.put("ssl.truststore.password", "sslpass")
        prodProps.put("ssl.keystore.location", "${LOCAL_FOLDER_LOCATION}ssl/server.keystore.jks")
        prodProps.put("ssl.keystore.password", "sslpass")
        prodProps.put("ssl.key.password", "sslpass")
        prodProps.put("security.protocol", "SASL_SSL")
        prodProps.put("sasl.mechanism", "PLAIN")

        var producer:KafkaProducer<String, String>? = null
        var rec:ProducerRecord<String, String>? = null
        try {
            val o = JsonObject()
            o.addProperty("hello", "Hi Test!")
            val message = o.toString()
            producer = KafkaProducer(prodProps)
            rec = ProducerRecord(topic, message)
            println("sending...")
        } catch (e:Exception) {
            e.printStackTrace()
            error=true
        } finally {
            producer?.send(rec)
            producer?.close()
        }

        if (error) return

        Thread.sleep(1000)

//        consumer
        val consumerConfig = Properties()
        consumerConfig.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, "localhost:9092")
        consumerConfig.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, "org.apache.kafka.common.serialization.StringDeserializer")
        consumerConfig.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, "org.apache.kafka.common.serialization.StringDeserializer")
        consumerConfig.put("ssl.truststore.location", "${LOCAL_FOLDER_LOCATION}ssl/client.truststore.jks")
        consumerConfig.put("ssl.truststore.password", "sslpass")
        consumerConfig.put("ssl.keystore.location", "${LOCAL_FOLDER_LOCATION}ssl/server.keystore.jks")
        consumerConfig.put("ssl.keystore.password", "sslpass")
        consumerConfig.put("ssl.key.password", "sslpass")
        consumerConfig.put("security.protocol", "SASL_SSL")
        consumerConfig.put("sasl.mechanism", "PLAIN")

        consumerConfig.put(ConsumerConfig.GROUP_ID_CONFIG, "mygroupid")
        consumerConfig.put(ConsumerConfig.CLIENT_ID_CONFIG, "mykafkaclientid2")


        var consumer:KafkaConsumer<String, String>? = null
        try {
            consumer =  KafkaConsumer(consumerConfig)
            consumer.subscribe(Collections.singletonList(topic))

            println("Consuming consumer")

            while (true) {
                val consumerRecords = consumer.poll(100)
                if (consumerRecords.count() > 0) {
                    consumerRecords.forEach { record ->
                        val o = gson.fromJson(record.value(), JsonObject::class.java)
                        Assert.assertTrue(o.s("hello")!!.contains("Hi Test!"))
                        System.out.printf("Consumer Record:(%d, %s, %d, %d)\n",
                                record.key(), record.value(),
                                record.partition(), record.offset())
                    }
                    break
                }

                consumer.commitAsync()
            }
        } finally {
            consumer?.close()
        }

    }
}