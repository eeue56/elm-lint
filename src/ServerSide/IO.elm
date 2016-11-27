module ServerSide.IO exposing (..)

import Json.Decode as Json
import Json.Encode as E
import Native.IO


{-|
    >>> loadJson "hello"
    Err "Cannot find module 'hello'"
-}
loadJson : String -> Result String Json.Value
loadJson filename = Native.IO.loadJson filename


currentDir : String
currentDir =
    Native.IO.currentDir

{-|
    >>> pathJoin "here" "okay"
    "here/okay"
-}
pathJoin : String -> String -> String
pathJoin =
    Native.IO.pathJoin


{-|
    >>> glob "impossible"
    []

    >>> glob "elm-package.json" |> List.length
    1
-}
glob : String -> List String
glob pattern =
    Native.IO.glob pattern


{-|
    >>> readFile "doesnotexist"
    Err "ENOENT: no such file or directory, open 'doesnotexist'"

-}
readFile : String -> Result String String
readFile filename =
    Native.IO.readFile filename
