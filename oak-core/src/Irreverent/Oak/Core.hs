{-# LANGUAGE NoImplicitPrelude #-}
-------------------------------------------------------------------
-- |
-- Module       : Irreverent.Oak.Core
-- Copyright    : (C) 2018 Irreverent Pixel Feats
-- License      : BSD-style (see the file /LICENSE.md)
-- Maintainer   : Dom De Re
--
-------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
module Irreverent.Oak.Core (
  -- * Re-exports
    module X
  , new
  , log
  , trace
  , debug
  , err
  , info
  , warn
  , fatal
  , withLogger
  ) where

import Ultra.Control.Monad.Bracket (MonadBracket, bracket')
import qualified Ultra.Data.Text as T
import qualified Ultra.Data.Text.Encoding as T

import qualified System.Logger as Log

import System.Logger as X (
    Level(..)
  , Logger
  , Output(..)
  , flush
  , close
  , clone
  )

import Preamble

new :: (MonadIO m) => Level -> Output -> Maybe T.Text -> m Logger
new lvl output' nm = Log.new
  . Log.setName nm
  . Log.setOutput output'
  . Log.setDelimiter (T.encodeUtf8 "|")
  . Log.setLogLevel lvl
  $ Log.defSettings

withLogger
  :: (MonadBracket m, MonadIO m)
  => Level
  -> Output
  -> Maybe T.Text
  -> (Logger -> m a)
  -> m a
withLogger lvl output' nm =
  bracket'
    (new lvl output' nm)
    (\logger -> flush logger >> close logger)


-- |
-- Msg -> Msg is a great idea and its efficient performance wise,
-- but its unfortunately not ubiquitous enough an idea
-- to make it portable (or i could be wrong, in which case ill
-- change this)
--
log :: (MonadIO m) => Logger -> Level -> T.Text -> m ()
log logger lvl = Log.log logger lvl . Log.msg

trace :: (MonadIO m) => Logger -> T.Text -> m ()
trace = flip log Log.Trace

debug :: (MonadIO m) => Logger -> T.Text -> m ()
debug = flip log Log.Debug

info :: (MonadIO m) => Logger -> T.Text -> m ()
info = flip log Log.Info

warn :: (MonadIO m) => Logger -> T.Text -> m ()
warn = flip log Log.Warn

err :: (MonadIO m) => Logger -> T.Text -> m ()
err = flip log Log.Error

fatal :: (MonadIO m) => Logger -> T.Text -> m ()
fatal = flip log Log.Fatal
