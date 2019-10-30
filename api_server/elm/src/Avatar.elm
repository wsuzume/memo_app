module Avatar exposing (..)

import Json.Encode as Encode exposing (Value)
import Json.Decode as Decode exposing (Decoder)

type Avatar
  = NoAvatar
  | Avatar String

encode : Avatar -> Value
encode avatar =
  case avatar of
      NoAvatar ->
          Encode.null
      Avatar string ->
          Encode.string string

fromMaybe : Maybe String -> Avatar
fromMaybe avatar =
  case avatar of
      Just string ->
          Avatar string
      Nothing ->
          NoAvatar

decoder : Decoder Avatar
decoder = Decode.map fromMaybe (Decode.nullable Decode.string)

toString : Avatar -> String
toString avatar =
    case avatar of
        NoAvatar ->
          ""
        Avatar string ->
          string

fromString : String -> Avatar
fromString string =
  if string == "" then
    NoAvatar
  else
    Avatar string
