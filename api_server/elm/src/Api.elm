module Api exposing (..)

import Browser
import Browser.Navigation as Nav
import Json.Decode as Decode exposing (Decoder, Value, decodeString, field, string)
import Json.Decode.Pipeline as Pipeline exposing (optional, required)
import Url exposing (Url)

import Viewer exposing (..)
import Username exposing (..)

type SessionID =
  SessionID String

type DogTag =
  DogTag Username SessionID

username : DogTag -> Username
username (DogTag val _) =
  val

usernameDecoder : Decoder Username
usernameDecoder =
  Decode.map Username string

sessionID : DogTag -> SessionID
sessionID (DogTag _ val) =
  val

sessionIDDecoder : Decoder SessionID
sessionIDDecoder =
  Decode.map SessionID string


dogtagDecoder : Decoder DogTag
dogtagDecoder =
  Decode.succeed DogTag
    |> required "username" usernameDecoder
    |> required "sessionID" sessionIDDecoder

decoderFromDogTag : Decoder (DogTag -> a) -> Decoder a
decoderFromDogTag decoder =
  Decode.map2 (\fromDogTag tag -> fromDogTag tag)
    decoder
    dogtagDecoder

decode : Decoder (DogTag -> viewer) -> Value -> Result Decode.Error viewer
decode decoder value =
    -- It's stored in localStorage as a JSON String;
    -- first decode the Value as a String, then
    -- decode that String as JSON.
    Decode.decodeValue Decode.string value
        |> Result.andThen (\str -> Decode.decodeString (Decode.field "user" (decoderFromDogTag decoder)) str)


-- APPLICATION

dummyDecoder : Decoder (DogTag -> Viewer)
dummyDecoder =
  Decode.succeed (\any -> Test)

--storageDecoder : Decoder (DogTag -> viewer) -> Decoder viewer
--storageDecoder viewerDecoder =
    --Decode.field "user" (decoderFromDogTag viewerDecoder)

application :
  Decoder (DogTag -> Viewer)
  ->
    { init : Maybe Viewer -> Url -> Nav.Key -> ( model, Cmd msg )
    , onUrlChange : Url -> msg
    , onUrlRequest : Browser.UrlRequest -> msg
    , subscriptions : model -> Sub msg
    , update : msg -> model -> ( model, Cmd msg )
    , view : model -> Browser.Document msg
    }
  -> Program Value model msg
application viewerDecoder config =
  let
    init flags url navKey =
      let
        maybeViewer =
          Just Test
          --Decode.decodeValue Decode.string flags
          --  |> Result.toMaybe
          --  |> Result.andThen (Decode.decodeString (storageDecoder viewerDecoder))
          --  |> Result.toMaybe
      in
      config.init maybeViewer url navKey
  in
  Browser.application
    { init = init
    , onUrlChange = config.onUrlChange
    , onUrlRequest = config.onUrlRequest
    , subscriptions = config.subscriptions
    , update = config.update
    , view = config.view
    }
