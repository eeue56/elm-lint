module Rules.Breakdown exposing (..)

import Array.Hamt as Array exposing (Array)
import Rules.Modules


type alias FileBreakdown =
    { moduleName : Array String
    , imports : Array String
    , body : Array String
    }

{-|
    >>> indexOfLineWithEquals
    ...     <| Array.fromList
    ...     <| String.lines "a\nb\nc = d\nf = d\n"
    2
-}
indexOfLineWithEquals : Array String -> Int
indexOfLineWithEquals =
    Array.foldl (\line (number, index) ->
        if number == -1 then
            if String.contains "=" line then
                (index, index)
            else
                (number, index + 1)
        else
            (number, index)
    ) (-1, 0)
        >> Tuple.first

{-|
    >>> indexOfLineWithImport
    ...     <| Array.fromList
    ...     <| String.lines "a\nb\nimport c\nf = d\n"
    2
-}
indexOfLineWithImport : Array String -> Int
indexOfLineWithImport =
    Array.foldl (\line (number, index) ->
        if number == -1 then
            if Rules.Modules.isImport line then
                (index, index)
            else
                (number, index + 1)
        else
            (number, index)
    ) (-1, 0)
        >> Tuple.first

{-|
    >>> createFileBreakdown "module A exposing (..)\nimport List\nf = List.map"
    { moduleName = Array.fromList [ "module A exposing (..)" ]
    , imports = Array.fromList ["import List"]
    , body = Array.fromList ["f = List.map"]
    }
-}
createFileBreakdown : String -> FileBreakdown
createFileBreakdown text =
    let
        asLines =
            String.lines text
                |> Array.fromList

        firstEquals =
            indexOfLineWithEquals asLines

        -- TODO: this can be optimzied by just looking at the lines up to the first equals
        firstImport =
            indexOfLineWithImport asLines
    in
        { moduleName =
            Array.slice 0 firstImport asLines
        , imports =
            Array.slice firstImport firstEquals asLines
        , body =
            Array.slice firstEquals (Array.length asLines) asLines
        }

