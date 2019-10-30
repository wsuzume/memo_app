module Route exposing (..)

import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s, string)

type Route
  = Home
  | Login
  | LocalStorage

parser : Parser (Route -> a) a
parser =
  oneOf
    [ Parser.map Home Parser.top
    , Parser.map Home (s "home")
    , Parser.map Login (s "login")
    , Parser.map LocalStorage (s "LocalStorage")
    ]


routeToString : Route -> String
routeToString route =
  let
    flagment =
      case route of
        Home ->
          [ "home" ]

        Login ->
          [ "login" ]

        LocalStorage ->
          [ "LocalStroage" ]
  in
    "/" ++ String.join "/" flagment


fromUrl : Url -> Maybe Route
fromUrl url =
  Parser.parse parser url
