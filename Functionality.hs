{-# LANGUAGE OverloadedStrings #-}

module Functionality where

import KlaczMonad
import IRC

import Prelude hiding (putStrLn)

import Control.Monad
import Control.Monad.Error
import Control.Monad.IO.Class
import Control.Applicative

import Data.Attoparsec.ByteString.Char8

import Data.Maybe
import Data.ByteString
import qualified Data.Set as S

import Network.FastIRC.Session
import Network.FastIRC.Types
import Network.FastIRC.Users


handlePrivMsg :: Maybe UserSpec -> S.Set TargetName -> ByteString -> Klacz ()
handlePrivMsg origin targets msg = do
  currentNick <- getCurrentNick
  case origin of
    Nothing -> liftIO $ putStrLn "Discarding message without origin"
    Just author -> parseAndHandleMessage (nickFromUserSpec author)
                     replyTo msg
      where replyTo = if S.null targets || S.member currentNick targets
                      then nickFromUserSpec author
                      else S.findMin targets

parseAndHandleMessage :: ByteString -> ByteString -> ByteString -> Klacz ()
parseAndHandleMessage author replyTo msg =
  case parse simpleCommandParser msg of
    Done _ (command, args) -> dispatchCommand command replyTo args
    Fail _ _ errMsg -> throwError $ ParseError errMsg
    where simpleCommandParser = do
            char ','
            skipSpace
            command <- takeTill (== ' ')
            skipSpace
            rest <- takeByteString
            return (command, rest)

dispatchCommand :: ByteString -> ByteString -> ByteString -> Klacz ()
dispatchCommand command replyTo args = undefined

helloCommand command replyTo args = undefined
  
