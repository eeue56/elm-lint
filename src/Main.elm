module Main exposing (..)

import Rules.Modules exposing (badModules, ModuleConfig)
import Platform

type alias Config =
    ModuleConfig {}


type alias Model =
    { config : Config }


type alias Flags =
    { configFile : Maybe String }

type Msg =
    NoOp

init : Flags -> (Model, Cmd Msg)
init flags =



main =
    Platform.programWithFlags

