module Main exposing (..)

import Rules.Modules exposing (badModules, ModuleConfig)
import Platform
import Json.Decode as Json
import ServerSide.IO
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
    }


type InitModel
    = BadFlags Flags
    | GoodFlags Model
    | BadElmPackage

type alias Flags =
    { configFile : Maybe String }

type alias RequiredFlags =
    { configFile : String }

type Msg =
    NoOp

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

loadElmPackage : Result String ElmPackage
loadElmPackage =
    ServerSide.IO.loadJson (ServerSide.IO.pathJoin ServerSide.IO.currentDir "/elm-package.json")
        |> Result.andThen (Json.decodeValue ElmPackage.decodeElmPackage)


failedToLoadConfig : Flags -> String -> (InitModel, Cmd Msg)
failedToLoadConfig flags message =
    let
        _ = Debug.log "Failed to load lint config!" message
    in
        (BadFlags flags, Cmd.none)


failedToLoadElmPackage : String -> (InitModel, Cmd Msg)
failedToLoadElmPackage message =
    let
        _ = Debug.log "Failed to load elm-package.json!" message
    in
        (BadElmPackage, Cmd.none)

tryToLoadElmPackage : Config -> Result (InitModel, Cmd Msg) (InitModel, Cmd Msg)
tryToLoadElmPackage config =
    loadElmPackage
        |> Result.mapError failedToLoadElmPackage
        |> Result.map (\elmPackageConfig ->
            (GoodFlags { elmPackageConfig = elmPackageConfig, config = config }, Cmd.none)
        )

{-|
    >>> either (Ok "")
    ""

    >>> either (Err "a")
    "a"
-}
either : Result a a -> a
either result =
    case result of
        Err v -> v
        Ok v -> v

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
        , update = (\msg model -> (model, Cmd.none) )
        , subscriptions = (\_ -> Sub.none)
        }
