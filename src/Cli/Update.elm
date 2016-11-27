module Cli.Update exposing (..)

import Cli.Types exposing (..)

type Msg =
    NoOp

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        NoOp ->
            (model, Cmd.none)



allUpdate : Msg -> InitModel -> (InitModel, Cmd Msg)
allUpdate msg initModel =
    case initModel of
        GoodFlags actualModel ->
            let
                (newModel, cmds) = update msg actualModel
            in
                (GoodFlags newModel, cmds)
        _ ->
            (initModel, Cmd.none)
