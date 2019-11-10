module Page.LocalStorage exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Browser
import Json.Decode as Decode
import Json.Encode as Encode

import Avatar exposing (..)
import Username exposing (..)
import CSRFToken exposing (..)
import SessionID exposing (..)
import Session exposing (..)
import Context exposing (..)

type alias Model =
  { username : String
  , session : Session
  , avatar : String
  , storedRoute : String
  , sessionID : String
  , csrfToken : String
  , privateKeyPrefix : String
  , sharedKeyPrefix : String
  , encoded : String
  }

readSession : Model -> Model
readSession model =
  let
      maybeCtx = Session.context model.session
  in
  case maybeCtx of
    Just ctx ->
      { model
      | username = Username.toString ctx.username
      , avatar = Avatar.toString ctx.avatar
      , storedRoute = ctx.storedRoute
      , sessionID = SessionID.toString ctx.sessionID
      , csrfToken = CSRFToken.toString ctx.csrfToken
      , privateKeyPrefix = ctx.privateKeyPrefix
      , sharedKeyPrefix = ctx.sharedKeyPrefix
      }
    Nothing ->
      model

type Msg
  = Username String
  | InputUsername String
  | InputAvatar String
  | InputStoredRoute String
  | InputSessionID String
  | InputCSRFToken String
  | InputPrivateKeyPrefix String
  | InputSharedKeyPrefix String
  | TryEncode
  | CacheData
  | LoadData
  | ReceiveData String

toSession : Model -> Session
toSession model =
  model.session

toContext : Model -> Context
toContext model =
  Context.Context
    (Username.fromString model.username)
    (Avatar.fromString model.avatar)
    model.storedRoute
    (SessionID.fromString model.sessionID)
    (CSRFToken.fromString model.csrfToken)
    model.privateKeyPrefix
    model.sharedKeyPrefix

init : Session -> ( Model, Cmd Msg )
init session =
  ( { username = ""
    , session = session
    , avatar = ""
    , storedRoute = ""
    , sessionID = ""
    , csrfToken = ""
    , privateKeyPrefix = ""
    , sharedKeyPrefix = ""
    , encoded = ""
    }
  , Cmd.none
  )

viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
  input [ type_ t, placeholder p, value v, onInput toMsg ] []

view : Model -> { title : String, content : Html Msg }
view model =
    { title = "LocalStorage"
    , content =
        div [ class "local-storage-page" ]
            [ h1 [] [ text "LocalStorage" ]
            , div [ class "context-viewer" ]
                  [ p [] [ text "Username: ", text model.username ]
                  , p [] [ text "Avatar: ", text model.avatar ]
                  , p [] [ text "StoredRoute: ", text model.storedRoute ]
                  , p [] [ text "SessionID: ", text model.sessionID ]
                  , p [] [ text "CSRFToken: ", text model.csrfToken ]
                  , p [] [ text "privateKeyPrefix: ", text model.privateKeyPrefix ]
                  , p [] [ text "sharedKeyPrefix: ", text model.sharedKeyPrefix ]
                  ]
            , hr [] []
            , div [ class "input-form" ]
                  [ p [] [ text "Username: ", viewInput "text" "Username" model.username InputUsername ]
                  , p [] [ text "Avatar: ", viewInput "text" "Avatar" model.avatar InputAvatar ]
                  , p [] [ text "StoredRoute: ", viewInput "text" "StoredRoute" model.storedRoute InputStoredRoute ]
                  , p [] [ text "SessionID: ", viewInput "text" "SessionID" model.sessionID InputSessionID ]
                  , p [] [ text "CSRFToken: ", viewInput "text" "CSRFToken" model.csrfToken InputCSRFToken ]
                  , p [] [ text "privateKeyPrefix: ", viewInput "text" "privateKeyPrefix" model.privateKeyPrefix InputPrivateKeyPrefix ]
                  , p [] [ text "sharedKeyPrefix: ", viewInput "text" "sharedKeyPrefix" model.sharedKeyPrefix InputSharedKeyPrefix ]
                  , p [] [ button [ onClick CacheData ] [ text "CacheData" ]
                         , button [ onClick LoadData ] [ text "LoadData" ]
                         , button [ onClick TryEncode ] [ text "TryEncode" ]
                         ]
                  ]
            , hr [] []
            , div []
                  [ text model.encoded ]
            ]
    }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case ( msg, model ) of
    ( InputUsername username, _ ) ->
      ( { model | username = username }, Cmd.none )

    ( InputAvatar avatar, _ ) ->
      ( { model | avatar = avatar }, Cmd.none )

    ( InputStoredRoute route , _ ) ->
      ( { model | storedRoute = route }, Cmd.none )

    ( InputSessionID sessionID, _ ) ->
      ( { model | sessionID = sessionID }, Cmd.none )

    ( InputCSRFToken token , _ ) ->
      ( { model | csrfToken = token }, Cmd.none )

    ( InputPrivateKeyPrefix key , _ ) ->
      ( { model | privateKeyPrefix = key }, Cmd.none )

    ( InputSharedKeyPrefix key , _ ) ->
      ( { model | sharedKeyPrefix = key }, Cmd.none )

    ( TryEncode, _ ) ->
      let
        val = Context.encoder (toContext model)
        disp = Encode.encode 2 val
      in
      ( { model | encoded = disp }, Cmd.none)

    ( CacheData, _ ) ->
      --( model, portSetLocalStorage model.avatar )
      ( model, Context.save (toContext model) )

    ( LoadData, _ ) ->
      ( model, Context.load )

    ( ReceiveData v, _ ) ->
      let
          maybeContext = Context.decodeString v
          --_ = Debug.log "hoge" maybeContext
      in
      case maybeContext of
        Just ctx ->
          ( { model | avatar = Avatar.toString ctx.avatar }, Cmd.none )
        Nothing ->
          ( model, Cmd.none )

    ( _, _ ) ->
      -- Disregard messages that arrived for the wrong page.
      ( model, Cmd.none )

subscriptions : Model -> Sub Msg
subscriptions model =
  Context.portRecvLocalContext ReceiveData
