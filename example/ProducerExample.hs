{-# LANGUAGE OverloadedStrings #-}

module ProducerExample
where

import Control.Monad (forM_)
import Data.Monoid
import Kafka.Producer

-- Global producer properties
producerProps :: ProducerProperties
producerProps = producerBrokersList [BrokerAddress "localhost:9092"]
             <> producerLogLevel KafkaLogDebug

-- Topic to send messages to
targetTopic :: TopicName
targetTopic = TopicName "kafka-client-example-topic"

-- Run an example
runProducerExample :: IO ()
runProducerExample = do
    res <- runProducer producerProps sendMessages
    print $ show res

sendMessages :: KafkaProducer -> IO (Either KafkaError String)
sendMessages prod = do
  err1 <- produceMessage prod ProducerRecord
                                { prTopic = targetTopic
                                , prPartition = UnassignedPartition
                                , prKey = Nothing
                                , prValue = Just "test from producer"
                                }
  forM_ err1 print

  err2 <- produceMessage prod ProducerRecord
                                { prTopic = targetTopic
                                , prPartition = UnassignedPartition
                                , prKey = Just "key"
                                , prValue = Just "test from producer (with key)"
                                }
  forM_ err2 print

  return $ Right "All done, Sir."
