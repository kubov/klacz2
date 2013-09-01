{-# LANGUAGE OverloadedStrings #-}

module Main where

import KlaczMonad
import IRC
import Functionality

import Network.Fancy
import Network.FastIRC
import Network.FastIRC.Session

import Control.Monad.State
import Control.Monad.Error
import Control.Applicative

import qualified Data.Map as M

configNickname = return "klacz2Adam"
configUser = return "klacz"
configRealName = return "Klacz"
configPassword = Nothing
configAddress = IPv4 "irc.freenode.net" 6667

klaczParams = Params
              configNickname
              configUser
              configRealName
              configPassword
              configAddress

configChannels = ["#klacztest"]

botOnConnect :: Bot ()
botOnConnect = do
  ircJoin configChannels

dispatchMessage :: Message -> Bot (Either KlaczError ())
dispatchMessage message = runErrorT $ do
  case msgCommand message of
    PrivMsgCmd targets msgText ->
      handlePrivMsg (msgOrigin message) targets msgText
    _ -> throwError $
         UnhandledMessage message
  

botOnMessage :: Message -> Bot ()
botOnMessage message = do
  result <- dispatchMessage message
  case result of
    Left error -> liftIO . putStrLn . show $ error
    Right () -> return ()

initBot :: BotSession -> IO ()
initBot session = do
  onConnect session botOnConnect
  onMessage session botOnMessage
  return ()

main = do
  r <- startBot klaczParams
  case r of
    Left err -> putStrLn . show $ err
    Right session -> initBot session >> waitForInput

waitForInput = do
  _ <- getLine
  return ()
