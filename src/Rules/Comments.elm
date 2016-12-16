module Rules.Comments exposing (..)

import Tokens

{-|
    >>> import Tokens exposing (docCommentOpen, multilineCommentClose, multilineCommentOpen)

    >>> isDocComment (docCommentOpen ++ " okay " ++ multilineCommentClose)
    True
    >>> isDocComment (multilineCommentOpen ++ " okay " ++ multilineCommentClose)
    False
-}
isDocComment : String -> Bool
isDocComment =
    String.trim >> String.startsWith Tokens.docCommentOpen

{-|
    >>> import Tokens exposing (docCommentOpen, multilineCommentClose, multilineCommentOpen)

    >>> isMultiLineComment ""
    False
    >>> isMultiLineComment (docCommentOpen ++ " okay " ++ multilineCommentClose)
    False
    >>> isMultiLineComment (multilineCommentOpen ++ " okay " ++ multilineCommentClose)
    True
-}
isMultiLineComment : String -> Bool
isMultiLineComment str =
    String.trim str
        |> String.startsWith Tokens.multilineCommentOpen
        |> ((&&) (not (isDocComment str)))

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
    String.trim >> String.startsWith Tokens.singleLineCommentOpen

{-|
    >>> stripComments "hello -- dont"
    "hello "

    >>> stripComments "-- hello"
    ""
-}
stripComments : String -> String
stripComments =
    String.split Tokens.singleLineCommentOpen
        >> List.head
        >> Maybe.withDefault ""
