module Main exposing (..)

import Rules.Modules exposing (badModules, ModuleConfig)
import Platform
import Json.Decode as Json
import ServerSide.IO

type alias Config =
    ModuleConfig {}

decodeConfig : Json.Decoder Config
decodeConfig =
    Json.map (\modules -> { badModuleNames = modules})
        (Json.field "badModuleNames" (Json.dict Json.string))


type alias Model =
    { config : Config }


type InitModel
    = BadFlags Flags
    | GoodFlags Model

type alias Flags =
    { configFile : Maybe String }

type alias RequiredFlags =
    { configFile : String }

type Msg =
    NoOp

toRequiredFlags : Flags -> RequiredFlags
toRequiredFlags flags =
    { configFile = Maybe.withDefault ".elm-lint-conf" flags.configFile
    }

loadConfig : RequiredFlags -> Result String Config
loadConfig flags =
    ServerSide.IO.loadJson flags.configFile
        |> Result.andThen (Json.decodeValue decodeConfig)


init : Flags -> (InitModel, Cmd Msg)
init flags =
    let
        withDefaults = toRequiredFlags flags
    in
        case loadConfig withDefaults of
            Err message ->
                let
                    _ = Debug.log "bad flags!" message
                in
                    (BadFlags flags, Cmd.none)
            Ok config ->
                let
                    _ = Debug.log "Loaded config successfully.." ""
                in
                    (GoodFlags { config = config }, Cmd.none)


main : Program Flags InitModel Msg
main =
    Platform.programWithFlags
        { init = init
        , update = (\msg model -> (model, Cmd.none) )
        , subscriptions = (\_ -> Sub.none)
        }
