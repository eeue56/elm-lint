module Cli.Messages exposing (..)

import Cli.Types exposing (Flags, InitModel(..))
import Cli.Update exposing (Msg)


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
