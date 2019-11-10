port module Context exposing (..)

import Json.Encode as Encode exposing (encode)
import Json.Decode as Decode exposing (Decoder, Value, decodeString, field, string)
import Json.Decode.Pipeline as Pipeline exposing (optional, required, requiredAt)

import Username exposing (..)
import Avatar exposing (..)
import SessionID exposing (..)
import CSRFToken exposing (..)

-- OUTGOING PORT
port portSetLocalContext : String -> Cmd msg
port portGetLocalContext : String -> Cmd msg

port portSetLocalStorage : ( String, String ) -> Cmd msg
port portGetLocalStorage : String -> Cmd msg

-- INCOMING PORT
port portRecvLocalContext : ( String -> msg ) -> Sub msg

port portRecvLocalStorage : (( String, String ) -> msg ) -> Sub msg

type alias Context =
  { username : Username
  , avatar : Avatar
  , storedRoute : String
  , sessionID : SessionID
  , csrfToken : CSRFToken
  , privateKeyPrefix : String
  , sharedKeyPrefix : String
  }


--csrf_token : Decoder CSRFToken
--csrf_token = Decode.map CSRFToken string
--    Decoder.string
--        |> Decoder.andThen
--            (\string ->
--                case string of
--                    "InvalidCSRFToken" ->
--                        Decoder.succeed InvalidCSRFToken
--
--                    "CSRFToken" ->
--                        Decoder.succeed CSRFToken
--
--                    _ ->
--                        Decoder.fail "Invalid CSRFToken"
--            )


decoder : Decoder Context
decoder =
  Decode.succeed Context
    |> requiredAt [ "user", "username" ] Username.decoder
    |> requiredAt [ "user", "avatar" ] Avatar.decoder
    |> requiredAt [ "user", "storedRoute" ] string
    |> requiredAt [ "user", "sessionID" ] SessionID.decoder
    |> requiredAt [ "user", "csrfToken" ] CSRFToken.decoder
    |> requiredAt [ "config", "privateKeyPrefix" ] string
    |> requiredAt [ "config", "sharedKeyPrefix" ] string

decodeString : String -> Maybe Context
decodeString s =
  --let _ = Debug.log "hoge" s in
  Decode.decodeString decoder s
   |> Result.toMaybe

decodeValue : Value -> Maybe Context
decodeValue v =
  Decode.decodeValue decoder v
   |> Result.toMaybe

encoder : Context -> Value
encoder ctx =
  Encode.object
  [ ( "user", Encode.object
    [ ( "username", Username.encode ctx.username )
    , ( "avatar", Avatar.encode ctx.avatar )
    , ( "storedRoute", Encode.string ctx.storedRoute )
    , ( "sessionID", SessionID.encode ctx.sessionID )
    , ( "csrfToken", CSRFToken.encode ctx.csrfToken )
    ] )
  , ( "config", Encode.object
    [ ( "privateKeyPrefix", Encode.string ctx.privateKeyPrefix )
    , ( "sharedKeyPrefix", Encode.string ctx.sharedKeyPrefix )
    ])
  ]

save : Context -> Cmd msg
save ctx =
  Encode.encode 0 (encoder ctx)
    |> portSetLocalContext

load : Cmd msg
load =
  portGetLocalContext ""
