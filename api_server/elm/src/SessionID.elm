module SessionID exposing (..)

import Json.Encode as Encode exposing (Value)
import Json.Decode as Decode exposing (Decoder)

type SessionID
  = InvalidSessionID
  | SessionID String

encode : SessionID -> Value
encode sessionID =
  case sessionID of
      InvalidSessionID ->
          Encode.null
      SessionID string ->
          Encode.string string

fromMaybe : Maybe String -> SessionID
fromMaybe sessionID =
  case sessionID of
      Just string ->
          SessionID string
      Nothing ->
          InvalidSessionID

decoder : Decoder SessionID
decoder = Decode.map fromMaybe (Decode.nullable Decode.string)

toString : SessionID -> String
toString sessionID =
    case sessionID of
        InvalidSessionID ->
          ""
        SessionID string ->
          string

fromString : String -> SessionID
fromString string =
  if string == "" then
    InvalidSessionID
  else
    SessionID string
