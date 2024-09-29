module Main where

import Prelude

import Data.String (Pattern(..), Replacement(..), replace)
import Effect (Effect)
import Effect.Console (log)
import Web.Event.EventTarget (addEventListener, eventListener)
import Web.HTML (window)
import Web.HTML.Location (href, reload)
import Web.HTML.Window (location)
import Web.Socket.Event.EventTypes (onMessage)
import Web.Socket.WebSocket as WS


main :: Effect Unit
main = do
  reloadHandler
  log "🍝"

reloadHandler :: Effect Unit
reloadHandler = do
  http_url <- window >>= location >>= href
  let ws_url = replace (Pattern "http") (Replacement "ws") http_url <> "ws"
  ws <- WS.create ws_url []
  let reloadPage = const $ window >>= location >>= reload
  messageListener <- eventListener reloadPage 
  addEventListener onMessage messageListener true (WS.toEventTarget ws)



