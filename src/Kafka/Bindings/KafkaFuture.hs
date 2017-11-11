{-# LANGUAGE DataKinds        #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE MagicHash        #-}
{-# LANGUAGE TypeFamilies     #-}
{-# LANGUAGE TypeOperators    #-}
module Kafka.Bindings.KafkaFuture
where

import Java
import Java.Collections as J
import Java.Concurrent

-- data {-# CLASS "org.apache.kafka.clients.consumer.KafkaConsumer" #-} JKafkaConsumer k v =
--   JKafkaConsumer (Object# (JKafkaConsumer k v))
--   deriving Class

-- data KafkaFuture a = KafkaFuture @org.apache.kafka.common.KafkaFuture a deriving (Class)

data {-# CLASS "org.apache.kafka.common.KafkaFuture" #-} KafkaFuture a =
  KafkaFuture (Object# (KafkaFuture a)) deriving Class

type instance Inherits (KafkaFuture a) = '[Future a]


-- foreign import java unsafe "@static org.apache.kafka.common.KafkaFuture.completedFuture" kafkaFutureCompleted :: (a <: Object) -> KafkaFuture a

-- foreign import java unsafe "complete" kafkaFutureComplete :: (a <: Object) => KafkaFuture a -> a -> IO Bool
-- foreign import java unsafe "cancel" kafkaFutureCancel :: KafkaFuture a -> Bool -> IO Bool
-- foreign import java unsafe "get" kafkaFutureGet :: (a <: Object) => KafkaFuture a -> IO a
-- foreign import java unsafe "getNow" kafkaFutureGetNow :: (a <: Object) => KafkaFuture a -> a -> IO a
-- foreign import java unsafe "isCancelled" kafkaFutureIsCancelled :: (a <: Object) => KafkaFuture a -> IO Bool
-- foreign import java unsafe "isDone" kafkaFutureIsDone :: KafkaFuture a -> IO Bool
