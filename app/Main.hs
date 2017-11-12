{-# LANGUAGE DataKinds        #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE MagicHash        #-}
{-# LANGUAGE TypeFamilies     #-}
{-# LANGUAGE TypeOperators    #-}
module Main where

import Control.Concurrent
import Data.Aeson
import Data.Map           as M
import Java
import Java.Collections   as J
import Java.Concurrent    as F
import Kafka.AdminClient
import Kafka.Types

props = M.fromList
  [ ("bootstrap.servers", "localhost:9092")
  ]

main :: IO ()
main = do
  -- let tp = newTopic "test-eta" 5 1 M.empty

  ac <- newAdminClient props

  listRes <- listTopics ac
  print listRes

  let topics = tiTopicName <$> listRes

  descRes <- describeTopics ac topics
  print descRes

  let createCmd = CreateTopic (TopicName "new-topic") (PartitionsCount 2) (ReplicationFactor 1) M.empty
  _ <- createTopics ac [createCmd]

  -- delRes <- deleteTopicsResultAll <$> adminClientDeleteTopics ac (topicListingName <$> topics)
  -- _ <- javaWith delRes F.get

  -- res <- createTopicsResultAll <$> adminClientCreateTopics ac [tp]
  -- _ <- javaWith res F.get

  -- lst <- listTopicsResultListings <$> adminClientListTopics ac
  -- javaWith lst F.get >>= (print . fromJavaCollection)

  -- print tp
  -- print (newTopicName tp)
  putStrLn "Ok."

-- fromJavaCollection :: Collection TopicListing -> [TopicListing]
-- fromJavaCollection = fromJava
