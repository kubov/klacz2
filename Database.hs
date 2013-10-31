{-# LANGUAGE EmptyDataDecls    #-}
{-# LANGUAGE FlexibleContexts  #-}
{-# LANGUAGE GADTs             #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}

module Database where

import Database.Persist
import Database.Persist.TH
import Database.Persist.Quasi
import Database.Persist.Postgresql
import Data.Pool (Pool)

import Data.Text (Text)
import Data.Time

share [mkPersist sqlOnlySettings, mkMigrate "migrateAll"]
        $(persistFileWith lowerCaseSettings "klacz.models")

pool_size = 5

type DBConnection = Pool Connection

-- http://hackage.haskell.org/package/persistent-postgresql-1.2.1/docs/Database-Persist-Postgresql.html#t:ConnectionString
{-withDatabase :: (MonadIO m) => ConnectionString -> -}
withDatabase cstr f = withPostgresqlPool cstr 5 f 


main :: IO ()
main = do
        let c = "host=localhost dbname=klacz user=klacz password=klacz"
        withDatabase c $ \pool -> do
            flip runSqlPersistMPool pool $ do
                runMigration migrateAll

