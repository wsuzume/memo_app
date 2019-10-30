import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url
import Json.Decode as Decode exposing (Value)



--import Page.Other as Other
import Page.Home as Home
import Page.LocalStorage as LocalStorage
--import Page.Login as Login
--import Page.Logout as Logout
--import Page.Signup as Signup
--import Page.Article as Article
--import Page.PublicList as PublicList
--import Page.PrivateList as PrivateList
--import Page.DraftList as DraftList
--import Page.MemoEditor as MemoEditor
--import Page.Settings as Settings

import Api as Api
import Context exposing (..)
import Viewer exposing (..)
import Page exposing (..)
import Route exposing (..)
import Session exposing (..)

-- MAIN

main : Program Value Model Msg
main =
  Api.application Context.decoder
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlChange = UrlChanged
    , onUrlRequest = LinkClicked
    }

-- MODEL


type Model
  = NotFound Session
  | Redirect Session
  | Home Home.Model
  | LocalStorage LocalStorage.Model


init : Maybe Context -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init maybeContext url key =
  changeRouteTo (Route.fromUrl url)
    (Redirect (Session.fromContext key maybeContext))

toSession : Model -> Session
toSession model =
  case model of
    NotFound session ->
      session
    Redirect session ->
      session
    Home home ->
      Home.toSession home
    LocalStorage storage ->
      LocalStorage.toSession storage


changeRouteTo : Maybe Route -> Model -> ( Model, Cmd Msg )
changeRouteTo maybeRoute model =
  let
      session = toSession model
  in
  case maybeRoute of
    Just Route.Home ->
      Home.init session
        |> updateWith Home GotHomeMsg model
    Just Route.LocalStorage ->
      LocalStorage.init session
        |> updateWith LocalStorage GotLocalStorageMsg model
    Nothing ->
      ( NotFound session, Cmd.none )
    _ ->
      ( NotFound session, Cmd.none )

-- UPDATE


type Msg
  = LinkClicked Browser.UrlRequest
  | UrlChanged Url.Url
  | GotHomeMsg Home.Msg
  | GotLocalStorageMsg LocalStorage.Msg

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case ( msg, model ) of
    ( LinkClicked urlRequest, _ ) ->
      case urlRequest of
        Browser.Internal url ->
          ( model, Nav.pushUrl (Session.navKey (toSession model)) (Url.toString url) )

        Browser.External href ->
          ( model, Nav.load href )

    ( UrlChanged url, _ ) ->
      changeRouteTo (Route.fromUrl url) model
      --( { model | url = url }
      --( model
      --, Cmd.none
      --)

    ( GotHomeMsg subMsg, Home home ) ->
      Home.update subMsg home
        |> updateWith Home GotHomeMsg model

    ( GotLocalStorageMsg subMsg, LocalStorage storage ) ->
      LocalStorage.update subMsg storage
        |> updateWith LocalStorage GotLocalStorageMsg model

    _ ->
      ( model, Cmd.none )


updateWith : (subModel -> Model) -> (subMsg -> Msg) -> Model -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg model ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )

-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  case model of
    LocalStorage storage ->
      Sub.map GotLocalStorageMsg (LocalStorage.subscriptions storage)
    _ ->
      Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
  let
    viewer = Maybe.map Viewer.fromContext (Session.context (toSession model))

    viewPage page toMsg config =
      let
        { title, body } =
            Page.view viewer page config
      in
      { title = title
      , body = List.map (Html.map toMsg) body
      }
  in
  case model of
    Home home ->
      viewPage Page.Home GotHomeMsg (Home.view home)

    LocalStorage storage ->
      viewPage Page.LocalStorage GotLocalStorageMsg (LocalStorage.view storage)

    _ ->
      { title = "NotFound"
      , body =
          [ text "NotFound"
          ]
      }
