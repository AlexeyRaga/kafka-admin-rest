module Kafka.Types
where

import Data.Int
import Data.Map as M

newtype TopicName = TopicName { unTopicName :: String} deriving (Show, Eq)
newtype PartitionsCount = PartitionsCount { unPartitionsCount :: Int} deriving (Show, Eq)
newtype ReplicationFactor = ReplicationFactor { unReplicationFactor :: Int} deriving (Show, Eq)
newtype BrokerId = BrokerId { unBrokerId :: Int} deriving (Show, Eq)
newtype PartitionId = PartitionId { unPartitionId :: Int } deriving (Show, Eq)

data CreateTopic = CreateTopic
  { ctTopicName         :: TopicName
  , ctPartitionsCount   :: PartitionsCount
  , ctReplicationFactor :: ReplicationFactor
  , ctTopicConfig       :: Map String String
  } deriving (Show)

data TopicInfo = TopicInfo
  { tiTopicName  :: TopicName
  , tiIsInternal :: Bool
  } deriving (Show)

data BrokerMetadata = BrokerMetadata
  { bmBrokerId :: BrokerId
  , bmIsEmpty  :: Bool
  , bmHost     :: String
  , bmPort     :: Int
  , bmRack     :: Maybe String
  } deriving (Show, Eq)

data PartitionMetadata = PartitionMetadata
  { pmPartitionId    :: PartitionId
  , pmLeader         :: BrokerMetadata
  , pmReplicas       :: [BrokerMetadata]
  , pmInSyncReplicas :: [BrokerMetadata]
  } deriving (Show, Eq)

data TopicMetadata = TopicMetadata
  { tmTopicName  :: TopicName
  , tmIsInternal :: Bool
  , tmPartitions :: [PartitionMetadata]
  } deriving (Show, Eq)
