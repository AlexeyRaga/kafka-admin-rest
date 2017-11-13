{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE TypeOperators #-}
module Kafka.Admin.RestAPI
where

import Control.Monad.IO.Class
import Data.Proxy
import Network.Wai
import Network.Wai.Servlet.Handler.Jetty
import Servant.API
import Servant.Server

import Kafka.Admin.AdminClient
import Kafka.Admin.Types

type KafkaAdminAPI = "topics" :> Get '[JSON] [TopicInfo]
                :<|> "topics" :> "describe" :> Capture "topic" String :> Get '[JSON] [TopicMetadata]
                :<|> "topics" :> "describe" :> QueryParams "topics" String :> Get '[JSON] [TopicMetadata]
                :<|> "topics" :> ReqBody '[JSON] [CreateTopic] :> PostNoContent '[JSON] NoContent
                :<|> "topics" :> ReqBody '[JSON] [String] :> DeleteNoContent '[JSON] NoContent

server :: AdminClient -> Server KafkaAdminAPI
server ac =  liftIO (listTopics ac)
        :<|> liftIO . describeTopics ac . replicate 1 . TopicName
        :<|> liftIO . describeTopics ac . (map TopicName)
        :<|> liftIO . noContent . createTopics ac
        :<|> liftIO . noContent . deleteTopics ac . (map TopicName)

noContent :: Monad m => m () -> m NoContent
noContent m = const NoContent <$> m

kafkaAdminAPI :: Proxy KafkaAdminAPI
kafkaAdminAPI = Proxy

runKafkaApi :: AdminClient -> Int -> IO ()
runKafkaApi ac port = run port (serve kafkaAdminAPI (server ac))
