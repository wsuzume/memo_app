module Username exposing (..)

import Json.Encode as Encode exposing (Value)
import Json.Decode as Decode exposing (Decoder)

type Username
  = Guest
  | Username String

encode : Username -> Value
encode username =
  case username of
      Guest ->
          Encode.null
      Username string ->
          Encode.string string

fromMaybe : Maybe String -> Username
fromMaybe username =
  case username of
      Just string ->
          Username string
      Nothing ->
          Guest

decoder : Decoder Username
decoder = Decode.map fromMaybe (Decode.nullable Decode.string)

toString : Username -> String
toString username =
    case username of
        Guest ->
          ""
        Username string ->
          string

fromString : String -> Username
fromString string =
  if string == "" then
    Guest
  else
    Username string
