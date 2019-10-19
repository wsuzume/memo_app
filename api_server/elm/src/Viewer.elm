module Viewer exposing (..)

import Username exposing (Username)

type Avatar =
  Avatar String

type Viewer
  = Viewer Username Avatar
  | Test
