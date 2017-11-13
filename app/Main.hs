{-# LANGUAGE DataKinds        #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE MagicHash        #-}
{-# LANGUAGE TypeFamilies     #-}
{-# LANGUAGE TypeOperators    #-}
module Main where

import Control.Concurrent
import Data.Aeson
import Data.Map                as M
import Java
import Java.Collections        as J
import Java.Concurrent         as F
import Kafka.Admin.AdminClient
import Kafka.Admin.RestAPI
import Kafka.Admin.Types
import Options

props = M.fromList
  [ ("bootstrap.servers", "localhost:9092")
  ]

main :: IO ()
main = do
  opts <- parseOptions
  let props = M.fromList [("bootstrap.servers", optBroker opts)]

  ac <- newAdminClient props

  runKafkaApi ac (optApiPort opts)

  putStrLn "Ok."
