module ElmPackage exposing (..)

import Json.Decode as Json

type alias ElmPackage =
    { sourceDirectories : List String
    }

decodeElmPackage : Json.Decoder ElmPackage
decodeElmPackage =
    Json.map ElmPackage
        (Json.field "source-directories" (Json.list Json.string))
