module Options
where

import Data.Monoid         ((<>))
import Options.Applicative
import Text.Read           (readEither)

data Options = Options
  { optBroker  :: String
  , optApiPort :: Int
  } deriving (Show)

optParser :: Parser Options
optParser = Options
  <$> strOption
    (  long "bootstrap-broker"
    <> metavar "HOST:PORT"
    <> help "Kafka broker address (localhost:9092)"
    )
  <*> readOption
    (  long "api-port"
    <> metavar "PORT"
    <> showDefault <> value 9099
    <> help "REST API port number"
    )

optParserInfo :: ParserInfo Options
optParserInfo = info (helper <*> optParser)
  (  fullDesc
  <> progDesc "Allows topic create/delete/describe/alter via REST interface"
  <> header "REST API for Kafka Admin API"
  )

readOption :: Read a => Mod OptionFields a -> Parser a
readOption = option $ eitherReader readEither

parseOptions :: IO Options
parseOptions = execParser optParserInfo
