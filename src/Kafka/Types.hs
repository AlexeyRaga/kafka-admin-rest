{-# LANGUAGE DeriveAnyClass             #-}
{-# LANGUAGE DeriveDataTypeable         #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
module Kafka.Types
where

import Data.Aeson
import Data.Int
import Data.Map     as M
import GHC.Generics

newtype TopicName = TopicName { unTopicName :: String} deriving (Show, Eq, Generic, ToJSON, FromJSON)
newtype PartitionsCount = PartitionsCount { unPartitionsCount :: Int} deriving (Show, Eq, Generic, ToJSON, FromJSON)
newtype ReplicationFactor = ReplicationFactor { unReplicationFactor :: Int} deriving (Show, Eq, Generic, ToJSON, FromJSON)
newtype BrokerId = BrokerId { unBrokerId :: Int} deriving (Show, Eq, Generic, ToJSON, FromJSON)
newtype PartitionId = PartitionId { unPartitionId :: Int } deriving (Show, Eq, Generic, ToJSON, FromJSON)

data CreateTopic = CreateTopic
  { ctTopicName         :: TopicName
  , ctPartitionsCount   :: PartitionsCount
  , ctReplicationFactor :: ReplicationFactor
  , ctTopicConfig       :: Map String String
  } deriving (Show, Generic)
instance ToJSON CreateTopic
instance FromJSON CreateTopic

data TopicInfo = TopicInfo
  { tiTopicName  :: TopicName
  , tiIsInternal :: Bool
  } deriving (Show, Generic)
instance ToJSON TopicInfo
instance FromJSON TopicInfo

data BrokerMetadata = BrokerMetadata
  { bmBrokerId :: BrokerId
  , bmIsEmpty  :: Bool
  , bmHost     :: String
  , bmPort     :: Int
  , bmRack     :: Maybe String
  } deriving (Show, Generic)
instance ToJSON BrokerMetadata
instance FromJSON BrokerMetadata

data PartitionMetadata = PartitionMetadata
  { pmPartitionId    :: PartitionId
  , pmLeader         :: BrokerMetadata
  , pmReplicas       :: [BrokerMetadata]
  , pmInSyncReplicas :: [BrokerMetadata]
  } deriving (Show, Generic)
instance ToJSON PartitionMetadata
instance FromJSON PartitionMetadata

data TopicMetadata = TopicMetadata
  { tmTopicName  :: TopicName
  , tmIsInternal :: Bool
  , tmPartitions :: [PartitionMetadata]
  } deriving (Show, Generic)
instance ToJSON TopicMetadata
instance FromJSON TopicMetadata
