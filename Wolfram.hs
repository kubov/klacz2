module Wolfram where

import Network.HTTP
import Text.XML.Light
import Control.Monad.Trans

wolframApiAddress = "http://api.wolframalpha.com/v2/query?"

wolframAppId = ""

makeUrl input = wolframApiAddress ++
                urlEncodeVars [("input", input), ("appid", wolframAppId)]

makeQuery query = do
  request <- simpleHTTP $ getRequest (makeUrl query)
  body <- getResponseBody request
  let document = return $ parseXMLDoc body
  case document of
    Just elements -> return $ Just elements
    Nothing -> return Nothing

