{-# LANGUAGE OverloadedStrings #-}
module Advice where

import qualified Data.Text as T
import System.Process
import System.Exit

scriptName :: T.Text
scriptName =  "./advice.sh"

runCommandText :: T.Text -> IO ProcessHandle
runCommandText cmd = runCommand $ T.unpack cmd

makeAdvice :: (T.Text, T.Text) -> T.Text -> T.Text -> IO Bool
makeAdvice (top, bottom) nick filename = do
  p <- runCommandText $ T.unwords [scriptName, nick, top, bottom, filename]
  exitCode <- waitForProcess p
  return $ case exitCode of
                ExitSuccess -> True
                _ -> False
