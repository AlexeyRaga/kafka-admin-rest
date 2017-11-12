{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE TypeOperators #-}
module Kafka.RestAPI
where

import Control.Monad.IO.Class
import Data.Proxy
import Network.Wai
import Network.Wai.Servlet.Handler.Jetty
import Servant.API
import Servant.Server

import Kafka.AdminClient
import Kafka.Types

type KafkaAdminAPI = "topics" :> "list" :> Get '[JSON] [TopicInfo]
                :<|> "topics" :> "describe" :> Capture "topic" String :> Get '[JSON] [TopicMetadata]
                :<|> "topics" :> "describe" :> QueryParams "topics" String :> Get '[JSON] [TopicMetadata]

server :: AdminClient -> Server KafkaAdminAPI
server ac =  liftIO (listTopics ac)
        :<|> liftIO . describeTopics ac . replicate 1 . TopicName
        :<|> liftIO . describeTopics ac . (map TopicName)

kafkaAdminAPI :: Proxy KafkaAdminAPI
kafkaAdminAPI = Proxy

runKafkaApi :: AdminClient -> Int -> IO ()
runKafkaApi ac port = run port (serve kafkaAdminAPI (server ac))
