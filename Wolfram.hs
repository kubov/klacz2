module Wolfram where

import Network.HTTP
import Text.XML.Light
import Control.Monad.Trans
import Control.Monad.Trans.Maybe

wolframApiAddress = "http://api.wolframalpha.com/v2/query?"

wolframAppId = ""

makeUrl input = wolframApiAddress ++
                urlEncodeVars [("input", input), ("appid", wolframAppId)]

makeQuery :: String -> MaybeT IO (Maybe Element)
makeQuery query = do
  request <- lift $ simpleHTTP $ getRequest (makeUrl query)
  body <- lift $ getResponseBody request
  return $ parseXMLDoc body


