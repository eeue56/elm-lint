module Helpers exposing (..)


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
