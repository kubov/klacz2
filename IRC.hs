module IRC where

import Control.Applicative
import Control.Monad.State
import Control.Monad.IO.Class

import Network.FastIRC.Session
import Network.FastIRC.Messages

import qualified Data.Map as M

ircJoin channels = do
  session <- botSession <$> get
  liftIO $ ircSendCmd session (JoinCmd channelMap)
    where channelMap = M.fromList (map (flip (,) Nothing) channels)

                   
