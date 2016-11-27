module Cli.Types exposing (..)

import Json.Decode as Json
import Rules.Modules exposing (badModules, ModuleConfig)
import ElmPackage exposing (ElmPackage)


type alias Config =
    ModuleConfig {}


decodeConfig : Json.Decoder Config
decodeConfig =
    Json.map (\modules -> { badModules = modules})
        (Json.field "badModules" (Json.dict Json.string))


type alias Model =
    { config : Config
    , elmPackageConfig : ElmPackage.ElmPackage
    , currentFilename : Maybe String
    }


type InitModel
    = BadFlags Flags
    | GoodFlags Model
    | BadElmPackage

type alias Flags =
    { configFile : Maybe String }

type alias RequiredFlags =
    { configFile : String }
