{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
-------------------------------------------------------------------
-- |
-- Module       : Irreverent.Oak.Options
-- Copyright    : (C) 2018 Irreverent Pixel Feats
-- License      : BSD-style (see the file /LICENSE.md)
-- Maintainer   : Dom De Re
--
-------------------------------------------------------------------
module Irreverent.Oak.Options (
  -- * Option parsers
    logLevelP
  ) where

import qualified Irreverent.Oak.Core as Log

import qualified Ultra.Data.Text as T
import Ultra.Options.Applicative (
    Parser
  , envvarWithDefaultWithRender
  , option
  , eitherTextReader
  )

import Data.List (lookup)

import Preamble

renderLogLevel :: Log.Level -> T.Text
renderLogLevel Log.Trace  = "trace"
renderLogLevel Log.Debug  = "debug"
renderLogLevel Log.Info   = "info"
renderLogLevel Log.Warn   = "warn"
renderLogLevel Log.Error  = "error"
renderLogLevel Log.Fatal  = "fatal"

loglevels :: [(T.Text, Log.Level)]
loglevels = (\x -> (renderLogLevel x, x)) <$> [
    Log.Trace
  , Log.Debug
  , Log.Info
  , Log.Warn
  , Log.Error
  , Log.Fatal
  ]

parseLogLevel :: T.Text -> Maybe Log.Level
parseLogLevel = flip lookup loglevels

eitherLogLevel :: T.Text -> Either T.Text Log.Level
eitherLogLevel t = maybe (Left t) pure $ parseLogLevel t

logLevelP :: [(T.Text, T.Text)] -> T.Text -> Parser Log.Level
logLevelP envs env = option (eitherTextReader eitherLogLevel) $ envvarWithDefaultWithRender
  parseLogLevel
  renderLogLevel
  envs
  env
  Log.Info
  "Logging Level (trace|debug|info|warn|error|fatal)"
