module Session exposing (..)

import Browser.Navigation as Nav

import Viewer exposing (..)

type Session
  = LoggedIn Nav.Key Viewer
  | Guset Nav.Key
  | TestSession

fromViewer : Nav.Key -> Maybe Viewer -> Session
fromViewer key maybeViewer =
  case maybeViewer of
    Just viewer ->
      LoggedIn key viewer

    Nothing ->
      Guset key
