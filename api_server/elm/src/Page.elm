module Page exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Browser

import Viewer exposing (..)

type Page
  = Other
  | Home
  | Login
  | LocalStorage
  | Logout
  | Register
  | Article
  | PublicList
  | PrivateList
  | DraftList
  | MemoEditor
  | Settings


view : Maybe Viewer -> Page -> { title : String, content : Html msg } -> Browser.Document msg
view maybeViewer page { title, content } =
  { title = title ++ " - SampleApp"
  , body = viewHeader page maybeViewer :: [ content ] }
--    , body = viewHeader page maybeViewer :: content :: [ viewFooter ]
--    }

viewLink : String -> String -> Html msg
viewLink str path =
  li [] [ a [ href path ] [ text str ] ]

viewHeader : Page -> Maybe Viewer -> Html msg
viewHeader page viewer =
  div [ class "page-header" ]
      [ ul []
          [ viewLink "Home" "/home"
          , viewLink "Login" "/login"
          , viewLink "LocalStorage" "/LocalStorage"
          ]
      ]
