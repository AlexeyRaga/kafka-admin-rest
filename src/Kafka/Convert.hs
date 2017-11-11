module Kafka.Convert
where

import Java
import Java.Collections
import Kafka.Bindings.Types as B
import Kafka.Types          as T

toTopicMetadata :: B.TopicDescription -> T.TopicMetadata
toTopicMetadata td = T.TopicMetadata
  { tmTopicName = TopicName (topicDescriptionName td)
  , tmIsInternal = topicDescriptionIsInternal td
  , tmPartitions = toPartitionMetadata <$> (fromJava $ topicDescriptionPartitions td)
  }

toPartitionMetadata :: B.TopicPartitionInfo -> T.PartitionMetadata
toPartitionMetadata p = T.PartitionMetadata
  { pmPartitionId = PartitionId (topicPartitionInfoPartition p)
  , pmLeader = toBrokerMetadata (topicPartitionInfoLeader p)
  , pmReplicas = toBrokerMetadata <$>  (fromJava $ topicPartitionInfoReplicas p)
  , pmInSyncReplicas = toBrokerMetadata <$> (fromJava $ topicPartitionInfoIsr p)
  }

toBrokerMetadata :: B.Node -> T.BrokerMetadata
toBrokerMetadata n = T.BrokerMetadata
  { bmBrokerId = BrokerId (nodeId n)
  , bmIsEmpty = nodeIsEmpty n
  , bmHost = nodeHost n
  , bmPort = nodePort n
  , bmRack = nodeRack n
  }
