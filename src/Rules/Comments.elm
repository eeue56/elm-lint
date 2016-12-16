module Rules.Comments exposing (..)


{-|
    >>> isSingleLineComment "-- hello"
    True
    >>> isSingleLineComment "  -- hello"
    True

    >>> isSingleLineComment "- hello"
    False
-}
isSingleLineComment : String -> Bool
isSingleLineComment =
    String.trim >> String.startsWith "--"

{-|
    >>> stripComments "hello -- dont"
    "hello "

    >>> stripComments "-- hello"
    ""
-}
stripComments : String -> String
stripComments =
    String.split "--"
        >> List.head
        >> Maybe.withDefault ""
