module Api exposing (..)

import Browser
import Browser.Navigation as Nav
import Json.Decode as Decode exposing (Decoder, Value, decodeString, field, string)
import Json.Decode.Pipeline as Pipeline exposing (optional, required)
import Url exposing (Url)

import Context exposing (..)
import Viewer exposing (..)
import Username exposing (..)
import SessionID exposing (..)


-- APPLICATION

--storageDecoder : Decoder (DogTag -> viewer) -> Decoder viewer
--storageDecoder viewerDecoder =
    --Decode.field "user" (decoderFromDogTag viewerDecoder)

application :
  Decoder context
  ->
    { init : Maybe context -> Url -> Nav.Key -> ( model, Cmd msg )
    , onUrlChange : Url -> msg
    , onUrlRequest : Browser.UrlRequest -> msg
    , subscriptions : model -> Sub msg
    , update : msg -> model -> ( model, Cmd msg )
    , view : model -> Browser.Document msg
    }
  -> Program Value model msg
application contextDecoder config =
  let
    init flags url navKey =
      let
        maybeContext =
          Decode.decodeValue contextDecoder flags
            |> Result.toMaybe
      in
      config.init maybeContext url navKey
  in
  Browser.application
    { init = init
    , onUrlChange = config.onUrlChange
    , onUrlRequest = config.onUrlRequest
    , subscriptions = config.subscriptions
    , update = config.update
    , view = config.view
    }
