{-# LANGUAGE MagicHash, FlexibleContexts, DataKinds, TypeFamilies #-}
module Kafka.Admin.Bindings.Types
where

import Java
import Java.Collections as J
import Data.Map as M
import Data.Bifunctor
import Kafka.Admin.Bindings.KafkaFuture

data Node = Node @org.apache.kafka.common.Node deriving (Class, Show)

foreign import java unsafe "@static org.apache.kafka.common.Node.noNode" emptyNode :: Node
foreign import java unsafe "isEmpty" nodeIsEmpty :: Node -> Bool
foreign import java unsafe "id" nodeId :: Node -> Int
foreign import java unsafe "host" nodeHost :: Node -> String
foreign import java unsafe "port" nodePort :: Node -> Int
foreign import java unsafe "rack" nodeRack :: Node -> Maybe String

data TopicPartitionInfo = TopicPartitionInfo @org.apache.kafka.common.TopicPartitionInfo deriving (Class, Show)
foreign import java unsafe "partition" topicPartitionInfoPartition :: TopicPartitionInfo -> Int
foreign import java unsafe "leader" topicPartitionInfoLeader :: TopicPartitionInfo -> Node
foreign import java unsafe "replicas" topicPartitionInfoReplicas :: TopicPartitionInfo -> List Node
foreign import java unsafe "isr" topicPartitionInfoIsr :: TopicPartitionInfo -> List Node

data AdminClient = AdminClient @org.apache.kafka.clients.admin.AdminClient deriving (Class)

foreign import java unsafe "@static org.apache.kafka.clients.admin.AdminClient.create" adminClientCtor :: J.Map JString JString -> IO AdminClient

data NewTopic = NewTopic @org.apache.kafka.clients.admin.NewTopic deriving (Class, Show)

foreign import java unsafe "@new" newTopicCtor :: String -> Int -> Short -> NewTopic
foreign import java unsafe "name" newTopicName :: NewTopic -> String
foreign import java unsafe "numPartitions" newTopicNumPartitions :: NewTopic -> Int
foreign import java unsafe "replicationFactor" newTopicReplicationFactor :: NewTopic -> Int
foreign import java unsafe "configs" newTopicSetConfigs :: NewTopic -> J.Map JString JString -> NewTopic

--------------------------------- CREATE TOPICS -------------------------------
foreign import java unsafe "createTopics" jAdminClientCreateTopics :: AdminClient -> Collection NewTopic -> IO CreateTopicsResult
adminClientCreateTopics :: AdminClient -> [NewTopic] -> IO CreateTopicsResult
adminClientCreateTopics c ts = jAdminClientCreateTopics c (toJava ts)

data CreateTopicsResult = CreateTopicsResult @org.apache.kafka.clients.admin.CreateTopicsResult deriving (Class)
foreign import java unsafe "values" createTopicsResultValues :: CreateTopicsResult -> J.Map JString (KafkaFuture Void)
foreign import java unsafe "all" createTopicsResultAll :: CreateTopicsResult -> KafkaFuture Void

--------------------------------- DELETE TOPICS -------------------------------
foreign import java unsafe "deleteTopics" jAdminClientDeleteTopics :: AdminClient -> Collection JString -> IO DeleteTopicsResult
adminClientDeleteTopics :: AdminClient -> [String] -> IO DeleteTopicsResult
adminClientDeleteTopics c ts = jAdminClientDeleteTopics c (toJava $ toJString <$> ts)

data DeleteTopicsResult = DeleteTopicsResult @org.apache.kafka.clients.admin.DeleteTopicsResult deriving (Class)
foreign import java unsafe "values" deleteTopicsResultValues :: DeleteTopicsResult -> J.Map JString (KafkaFuture Void)
foreign import java unsafe "all" deleteTopicsResultAll :: DeleteTopicsResult -> KafkaFuture Void

--------------------------------- LIST TOPICS ---------------------------------
foreign import java unsafe "listTopics" adminClientListTopics :: AdminClient -> IO ListTopicsResult

data TopicListing = TopicListing @org.apache.kafka.clients.admin.TopicListing deriving (Class, Show)
foreign import java unsafe "name" topicListingName :: TopicListing -> String
foreign import java unsafe "isInternal" topicListingIsInternal :: TopicListing -> Bool

data ListTopicsResult = ListTopicsResult @org.apache.kafka.clients.admin.ListTopicsResult deriving (Class)
foreign import java unsafe "listings" listTopicsResultListings :: ListTopicsResult -> (KafkaFuture (Collection TopicListing))

--------------------------------- DESCRIBE TOPICS -----------------------------
foreign import java unsafe "describeTopics" adminClientDescribeTopics :: AdminClient -> Collection JString -> IO DescribeTopicsResult

data DescribeTopicsResult = DescribeTopicsResult @org.apache.kafka.clients.admin.DescribeTopicsResult deriving (Class, Show)
foreign import java unsafe "values" describeTopicsResultValues :: DescribeTopicsResult -> J.Map JString (KafkaFuture TopicDescription)
foreign import java unsafe "all" describeTopicsResultAll :: DescribeTopicsResult -> KafkaFuture (J.Map JString TopicDescription)


data TopicDescription = TopicDescription @org.apache.kafka.clients.admin.TopicDescription deriving (Class, Show)
foreign import java unsafe "name" topicDescriptionName :: TopicDescription -> String
foreign import java unsafe "isInternal" topicDescriptionIsInternal :: TopicDescription -> Bool
foreign import java unsafe "partitions" topicDescriptionPartitions :: TopicDescription -> List TopicPartitionInfo

--------------------------------- DESCRIBE CLUSTER ----------------------------
foreign import java unsafe "describeTopics" adminClientDescribeCluster :: AdminClient -> IO DescribeClusterResult

data DescribeClusterResult = DescribeClusterResult @org.apache.kafka.clients.admin.DescribeClusterResult deriving (Class, Show)
foreign import java unsafe "nodes" describeClusterResultNodes :: DescribeClusterResult -> KafkaFuture (Collection Node)
foreign import java unsafe "controller" describeClusterResultController :: DescribeClusterResult -> KafkaFuture Node
foreign import java unsafe "clusterId" describeClusterResultClusterId :: DescribeClusterResult -> KafkaFuture (Maybe String)

