{-# LANGUAGE OverloadedStrings #-}
module Klacz where
import Control.Monad.Reader
import Database (DBConnection)
import Database.Persist.Postgresql

data Settings = Settings {
    database :: DBConnection
    }

type KlaczMonad = ReaderT Settings IO


runDB :: SqlPersistM a -> KlaczMonad a
runDB f = do
    p <- asks database
    lift $ runSqlPersistMPool f p

runKlacz = flip runReaderT

-- do testow, remove
runKlaczPool :: KlaczMonad a -> IO a
runKlaczPool f = do
    let cs = "host=localhost dbname=klacz user=klacz password=klacz"
    p <- createPostgresqlPool cs 2
    runKlacz (Settings p) f
