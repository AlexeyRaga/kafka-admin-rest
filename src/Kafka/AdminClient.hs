module Kafka.AdminClient
( AdminClient
, newAdminClient
, listTopics
, describeTopics
, createTopics
, deleteTopics
)
where

import Data.Bifunctor
import Data.Map         as M
import Java
import Java.Collections as J
import Java.Concurrent  as F

import Kafka.Bindings.KafkaFuture as J
import Kafka.Bindings.Types       as J
import Kafka.Convert
import Kafka.Types

newAdminClient :: M.Map String String -> IO AdminClient
newAdminClient c = adminClientCtor (toJavaMap c)

createTopics :: AdminClient -> [CreateTopic] -> IO ()
createTopics c ts = do
  res <- createTopicsResultAll <$> adminClientCreateTopics c (newTopic <$> ts)
  _ <- javaWith res F.get
  return ()

deleteTopics :: AdminClient -> [TopicName] -> IO ()
deleteTopics c ts = do
  res <- deleteTopicsResultAll <$> adminClientDeleteTopics c (unTopicName <$> ts)
  _ <- javaWith res F.get
  return ()

listTopics :: AdminClient -> IO [TopicInfo]
listTopics c = do
  res <- listTopicsResultListings <$> adminClientListTopics c
  ts <- javaWith res F.get
  return $ (\t -> TopicInfo (TopicName $ topicListingName t) (topicListingIsInternal t)) <$> fromJava ts

describeTopics :: AdminClient -> [TopicName] -> IO [TopicMetadata]
describeTopics c ts = do
  let tns = toJava $ (toJString . unTopicName) <$> ts
  res <- describeTopicsResultAll <$> adminClientDescribeTopics c tns
  ts <- javaWith res F.get
  let kvs = fromJava ts :: [(JString, TopicDescription)]
  return ((toTopicMetadata . snd) <$> kvs)

-------------------------------------------------------------------------------
newTopic :: CreateTopic -> NewTopic
newTopic ct =
  let (TopicName t) = ctTopicName ct
      (PartitionsCount p) = ctPartitionsCount ct
      (ReplicationFactor r) = ctReplicationFactor ct
      conf = ctTopicConfig ct
      nt = newTopicCtor t p (fromIntegral r)
  in if M.null conf then nt else newTopicSetConfigs nt (toJavaMap conf)

toJavaMap :: M.Map String String -> J.Map JString JString
toJavaMap m = toJava $ bimap toJString toJString <$> M.toList m

fromJavaCollection :: Collection TopicListing -> [TopicListing]
fromJavaCollection = fromJava
