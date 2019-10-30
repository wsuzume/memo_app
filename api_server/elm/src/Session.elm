module Session exposing (..)

import Browser.Navigation as Nav

import Viewer exposing (..)
import Context exposing (..)
import Username exposing (..)
import SessionID exposing (..)

type Session
  = User Nav.Key Context     -- Username and SessionID are valid
  | Expired Nav.Key Context  -- Username is valid but SessionID is invalid
  | GuestUser Nav.Key Context    -- Username is empty but SessionID is valid
  | NewGuestUser Nav.Key Context -- Username is empty and SessionID is empty or invalid
  | InvalidSession Nav.Key -- Couldn't get Context, is fatal and cannot be recovered

fromContext : Nav.Key -> Maybe Context -> Session
fromContext key maybeCtx =
  case maybeCtx of
    Just ctx ->
      case ( ctx.username, ctx.sessionID ) of
        ( Username _, SessionID _ ) ->
          User key ctx

        ( Username _, InvalidSessionID ) ->
          Expired key ctx

        ( Guest, SessionID _ ) ->
          GuestUser key ctx

        ( Guest, InvalidSessionID ) ->
          NewGuestUser key ctx

    Nothing ->
      InvalidSession key

updateContext : Session -> Context -> Session
updateContext session ctx =
  case session of
      User key _ ->
        User key ctx
      Expired key _ ->
        Expired key ctx
      GuestUser key _ ->
        GuestUser key ctx
      NewGuestUser key _ ->
        NewGuestUser key ctx
      InvalidSession key ->
        InvalidSession key

navKey : Session -> Nav.Key
navKey session =
  case session of
    User key _ ->
      key
    Expired key _ ->
      key
    GuestUser key _ ->
      key
    NewGuestUser key _ ->
      key
    InvalidSession key ->
      key

context : Session -> Maybe Context
context session =
  case session of
    User _ ctx ->
      Just ctx
    Expired _ ctx ->
      Just ctx
    GuestUser _ ctx ->
      Just ctx
    NewGuestUser _ ctx ->
      Just ctx
    InvalidSession _ ->
      Nothing
