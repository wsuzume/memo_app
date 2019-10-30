module CSRFToken exposing (..)

import Json.Encode as Encode exposing (Value)
import Json.Decode as Decode exposing (Decoder)

type CSRFToken
  = InvalidCSRFToken
  | CSRFToken String

encode : CSRFToken -> Value
encode token =
  case token of
      InvalidCSRFToken ->
          Encode.null
      CSRFToken string ->
          Encode.string string

fromMaybe : Maybe String -> CSRFToken
fromMaybe token =
  case token of
      Just string ->
          CSRFToken string
      Nothing ->
          InvalidCSRFToken

decoder : Decoder CSRFToken
decoder = Decode.map fromMaybe (Decode.nullable Decode.string)

toString : CSRFToken -> String
toString token =
    case token of
        InvalidCSRFToken ->
          ""
        CSRFToken string ->
          string

fromString : String -> CSRFToken
fromString string =
  if string == "" then
    InvalidCSRFToken
  else
    CSRFToken string
