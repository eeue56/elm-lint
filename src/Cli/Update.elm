module Cli.Update exposing (..)

import ElmPackage exposing (ElmPackage)
import Cli.Types exposing (..)
import ServerSide.IO exposing (glob, readFile)
import Helpers exposing (either)

import Rules.Modules exposing (suggestImprovements, ModuleConfig)

type Msg
    = NoOp
    | Start
    | ProcessFile String


allElmFilenames : ElmPackage -> List String
allElmFilenames =
    .sourceDirectories
        >> List.map (\name -> ServerSide.IO.pathJoin name "**elm")
        >> List.map glob
        >> List.concat


processFile : ModuleConfig a -> String -> Result String String
processFile config =
    readFile
        >> Result.map (String.lines >> suggestImprovements config >> String.join "\n")


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        NoOp ->
            (model, Cmd.none)

        Start ->
            let
                loadedFiles =
                    allElmFilenames model.elmPackageConfig

                _ =
                    List.map (processFile model.config >> either) loadedFiles
                        |> String.join "\n"
                        |> ServerSide.IO.log
            in
                (
                    { model
                    | allFilenames = loadedFiles
                    , currentFilename = List.head loadedFiles
                    }
                , Cmd.none
                )

        ProcessFile filename ->
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
