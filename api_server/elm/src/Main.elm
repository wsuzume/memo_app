import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url
import Json.Decode as Decode exposing (Value)



--import Page.Other as Other
import Page.Home as Home
--import Page.Login as Login
--import Page.Logout as Logout
--import Page.Signup as Signup
--import Page.Article as Article
--import Page.PublicList as PublicList
--import Page.PrivateList as PrivateList
--import Page.DraftList as DraftList
--import Page.MemoEditor as MemoEditor
--import Page.Settings as Settings

import Api as Api exposing (DogTag)
import Viewer exposing (..)
import Page exposing (..)
import Route exposing (..)
import Session exposing (..)

-- MAIN


main : Program Value Model Msg
main =
  Api.application Api.dummyDecoder
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlChange = UrlChanged
    , onUrlRequest = LinkClicked
    }



-- MODEL


type Model
  = Other
  | Redirect Session
  | Home Home.Model


init : Maybe Viewer -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init maybeViewer url key =
  changeRouteTo (Route.fromUrl url)
    (Redirect (Session.fromViewer key maybeViewer))

toSession : Model -> Session
toSession model =
  TestSession

changeRouteTo : Maybe Route -> Model -> ( Model, Cmd Msg )
changeRouteTo maybeRoute model =
  let
      session = toSession model
  in
  case maybeRoute of
    Just Route.Home ->
      Home.init session
        |> updateWith Home GotHomeMsg model
    Nothing ->
      ( Other, Cmd.none )
    _ ->
      ( Other, Cmd.none )

-- UPDATE


type Msg
  = LinkClicked Browser.UrlRequest
  | UrlChanged Url.Url
  | GotHomeMsg Home.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    LinkClicked urlRequest ->
      case urlRequest of
        Browser.Internal url ->
          --( model, Nav.pushUrl model.key (Url.toString url) )
          ( model, Cmd.none )

        Browser.External href ->
          ( model, Nav.load href )

    UrlChanged url ->
      --( { model | url = url }
      ( model
      , Cmd.none
      )

    _ ->
      ( model, Cmd.none )

updateWith : (subModel -> Model) -> (subMsg -> Msg) -> Model -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg model ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )

-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
  { title = "URL Interceptor"
  , body =
      [ viewHeader Test
      ]
  }
