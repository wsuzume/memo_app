module Viewer exposing (..)

import Username exposing (Username(..))
import Context exposing (..)

type Avatar =
  Avatar String

type Viewer
  = Viewer Username Avatar
  | Test

fromContext : Context -> Viewer
fromContext context =
  Viewer context.username (Avatar "aa")
