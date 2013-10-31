module Commands where

import qualified Data.Text as T
import Data.Time
import Database.Persist
import Control.Monad

import Database
import Klacz
import Control.Monad.IO.Class(liftIO)


addTerm :: Term -> KlaczMonad ()
addTerm t = void . runDB $ insert t

describeTerm :: T.Text -> KlaczMonad [Term]
describeTerm q = fmap (map entityVal) . runDB $
    selectList [TermName ==. q] []

addLink :: T.Text -> T.Text -> KlaczMonad Link
addLink nick url = do
    time <- liftIO getCurrentTime
    runDB $ do
        ex <- getBy $ UniqueLink url
        case ex of
             Nothing -> do
                 let l = Link url nick time 1
                 insert l
                 return l
             Just l -> updateGet (entityKey l) [LinkCount +=. 1]

identifyUser :: T.Text -> T.Text -> KlaczMonad (Maybe Int)
identifyUser user chan = runDB $ do
    u_ <- getBy $ UniqueUser user
    case u_ of       -- lol guwno, dac MaybeT or wut?
         Nothing -> return Nothing
         Just u -> do
             a <- getBy $ UniqueAccess chan $ entityKey u
             return $ fmap (accessLevel . entityVal) a

-- adds user if not known
setUserAccess :: T.Text -> T.Text -> Int -> KlaczMonad ()
setUserAccess user chan level = runDB $ do
    u_ <- insertBy $ User user
    let uid = case u_ of
            Left x -> entityKey x
            Right x -> x
    let acc = Access chan level uid
    a_ <- insertBy acc
    case a_ of
         Right _ -> return ()
         Left x -> replace (entityKey x) acc

