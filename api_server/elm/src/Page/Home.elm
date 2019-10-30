module Page.Home exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Browser

import Page exposing (..)
import Session exposing (..)

type alias Model =
  { username : String
  , session : Session
  }

type Msg =
  TestMsg

toSession : Model -> Session
toSession model =
    model.session

init : Session -> ( Model, Cmd Msg )
init session =
    ( { username = "fuga"
      , session = session
      }
    , Cmd.none
    )

view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Home"
    , content =
        div [ class "home-page" ]
            [ text "Home" ]
    }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( _, _ ) ->
            -- Disregard messages that arrived for the wrong page.
            ( model, Cmd.none )
