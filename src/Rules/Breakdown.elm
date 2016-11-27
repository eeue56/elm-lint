module Rules.Breakdown exposing (..)

import Array.Hamt as Array exposing (Array)


type alias FileBreakdown =
    { header : Array String
    , body : Array String
    }

{-|
    >>> indexOfLineWithEquals <| Array.fromList <| String.lines "a\nb\nc = d\nf = d\n"
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
    >>> createFileBreakdown "module A exposing (..)\nimport List\nf = List.map"
    { header = Array.fromList [ "module A exposing (..)", "import List"], body = Array.fromList ["f = List.map"]}
-}
createFileBreakdown : String -> FileBreakdown
createFileBreakdown text =
    let
        asLines =
            String.lines text
                |> Array.fromList

        firstEquals =
            indexOfLineWithEquals asLines
    in
        { header =
            Array.slice 0 firstEquals asLines
        , body =
            Array.slice firstEquals (Array.length asLines) asLines
        }

