{-# LANGUAGE OverloadedStrings #-}

module Main where

import IRC

import Network.Fancy
import Network.FastIRC
import Network.FastIRC.Session

import Control.Monad.State
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

initBot :: BotSession -> IO ()
initBot session = do
  onConnect session botOnConnect
  return ()

main = do
  r <- startBot klaczParams
  case r of
    Left err -> putStrLn . show $ err
    Right session -> initBot session >> waitForInput

waitForInput = do
  _ <- getLine
  return ()
