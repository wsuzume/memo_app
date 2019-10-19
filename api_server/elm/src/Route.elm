module Route exposing (..)

import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s, string)

type Route
  = Home
  | Login

parser : Parser (Route -> a) a
parser =
  oneOf
    [ Parser.map Home Parser.top
    , Parser.map Login (s "login")
    ]


routeToString : Route -> String
routeToString route =
  let
    flagment =
      case route of
        Home ->
          []

        Login ->
          [ "login" ]
  in
    "/" ++ String.join "/" flagment


fromUrl : Url -> Maybe Route
fromUrl url =
  Parser.parse parser url
