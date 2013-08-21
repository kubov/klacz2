{-# LANGUAGE OverloadedStrings #-}

module Main where

import Network.Fancy
import Network.FastIRC
import Network.FastIRC.Session

configNickname = return "klacz2"
configUser = return "klacz"
configRealName = return "Klacz"
configPassword = Nothing
configAddress = IPv4 "localhost" 6667

klaczParams = Params
              configNickname
              configUser
              configRealName
              configPassword
              configAddress

botOnConnect = return ()

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
