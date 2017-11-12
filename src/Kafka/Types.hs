-- {-# LANGUAGE DeriveAnyClass     #-}
{-# LANGUAGE DeriveDataTypeable         #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Kafka.Types
where

import Data.Aeson
import Data.Char       (toLower)
import Data.Int
import Data.Map        (Map)
import GHC.Generics
import Web.HttpApiData

newtype TopicName = TopicName { unTopicName :: String } deriving (Show, Eq, Generic, ToJSON, FromJSON)
newtype PartitionsCount = PartitionsCount { unPartitionCount :: Int } deriving (Show, Eq, Generic, ToJSON, FromJSON)
newtype ReplicationFactor = ReplicationFactor { unReplicationFactor :: Int } deriving (Show, Eq, Generic, ToJSON, FromJSON)
newtype BrokerId = BrokerId { unBrokerId :: Int } deriving (Show, Eq, Generic, ToJSON, FromJSON)
newtype PartitionId = PartitionId { unPartitionId :: Int } deriving (Show, Eq, Generic, ToJSON, FromJSON)

data CreateTopic = CreateTopic
  { ctTopicName         :: TopicName
  , ctPartitionsCount   :: PartitionsCount
  , ctReplicationFactor :: ReplicationFactor
  , ctTopicConfig       :: Map String String
  } deriving (Show, Generic)

instance ToJSON CreateTopic where
  toJSON = genericToJSON jsonOptions

instance FromJSON CreateTopic where
  parseJSON = genericParseJSON jsonOptions

data TopicInfo = TopicInfo
  { tiTopicName  :: TopicName
  , tiIsInternal :: Bool
  } deriving (Show, Generic)

instance ToJSON TopicInfo where
  toJSON = genericToJSON jsonOptions

instance FromJSON TopicInfo where
  parseJSON = genericParseJSON jsonOptions

data BrokerMetadata = BrokerMetadata
  { bmBrokerId :: BrokerId
  , bmIsEmpty  :: Bool
  , bmHost     :: String
  , bmPort     :: Int
  , bmRack     :: Maybe String
  } deriving (Show, Generic)

instance ToJSON BrokerMetadata where
  toJSON = genericToJSON jsonOptions

instance FromJSON BrokerMetadata where
  parseJSON = genericParseJSON jsonOptions

data PartitionMetadata = PartitionMetadata
  { pmPartitionId    :: PartitionId
  , pmLeader         :: BrokerMetadata
  , pmReplicas       :: [BrokerMetadata]
  , pmInSyncReplicas :: [BrokerMetadata]
  } deriving (Show, Generic)

instance ToJSON PartitionMetadata where
  toJSON = genericToJSON jsonOptions

instance FromJSON PartitionMetadata where
  parseJSON = genericParseJSON jsonOptions

data TopicMetadata = TopicMetadata
  { tmTopicName  :: TopicName
  , tmIsInternal :: Bool
  , tmPartitions :: [PartitionMetadata]
  } deriving (Show, Generic)

instance ToJSON TopicMetadata where
  toJSON = genericToJSON jsonOptions

instance FromJSON TopicMetadata where
  parseJSON = genericParseJSON jsonOptions

jsonOptions :: Options
jsonOptions = defaultOptions { fieldLabelModifier=camelCase.drop 2, omitNothingFields=True }

camelCase :: String -> String
camelCase []     = []
camelCase (x:xs) = (toLower x):xs
{-# INLINE camelCase #-}
