module Main exposing (..)

import Platform
import Json.Decode as Json
import Task

import ElmPackage
import ServerSide.IO
import Helpers exposing (either)

import Cli.Types exposing (..)
import Cli.Messages exposing (..)
import Cli.Update exposing (..)


toRequiredFlags : Flags -> RequiredFlags
toRequiredFlags flags =
    { configFile =
        Maybe.withDefault "elm-lint-conf.json" flags.configFile
            |> (\path -> ServerSide.IO.pathJoin ServerSide.IO.currentDir path)
    }

loadConfig : RequiredFlags -> Result String Config
loadConfig flags =
    ServerSide.IO.loadJson flags.configFile
        |> Result.andThen (Json.decodeValue decodeConfig)

loadElmPackage : Result String ElmPackage.ElmPackage
loadElmPackage =
    ServerSide.IO.loadJson (ServerSide.IO.pathJoin ServerSide.IO.currentDir "/elm-package.json")
        |> Result.andThen (Json.decodeValue ElmPackage.decodeElmPackage)


tryToLoadElmPackage : Config -> Result (InitModel, Cmd Msg) (InitModel, Cmd Msg)
tryToLoadElmPackage config =
    loadElmPackage
        |> Result.mapError failedToLoadElmPackage
        |> Result.map (\elmPackageConfig ->
            (GoodFlags
                { elmPackageConfig = elmPackageConfig
                , config = config
                , currentFilename = Nothing
                , allFilenames = []
                }
            , Task.perform (\_ -> Start) (Task.succeed ())
            )
        )

init : Flags -> (InitModel, Cmd Msg)
init flags =
    let
        withDefaults = toRequiredFlags flags
    in
        loadConfig withDefaults
            |> Result.mapError (failedToLoadConfig flags)
            |> Result.andThen (\config -> tryToLoadElmPackage config)
            |> either


main : Program Flags InitModel Msg
main =
    Platform.programWithFlags
        { init = init
        , update = allUpdate
        , subscriptions = (\_ -> Sub.none)
        }
