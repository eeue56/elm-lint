module Rules.Types exposing (..)

import Dict exposing (Dict)
import List.Extra


type KnownTypes
    = MaybeType KnownTypes
    | ListType KnownTypes
    | IntType
    | FloatType
    | BoolType
    | StringType
    | ComplexType
    | ResolvedType String
    | Unknown



type alias UnionType =
    { name : String
    , fields : Dict String KnownTypes
    }

{-|
    >>> isUnionType "type Action = NoOp"
    True

    >>> isUnionType "type alias Action = {}"
    False
-}
isUnionType : String -> Bool
isUnionType input =
    if String.startsWith "type" input then
        String.startsWith "type alias" input
            |> not
    else
        False

{-|
    >>> import Dict exposing (fromList)

    >>> createUnionType "type Action = NoOp"
    Ok { name = "Action", fields = fromList [("NoOp", ResolvedType "NoOp")] }

    >>> createUnionType "type alias Action = {}"
    Err "not a union type"
-}
createUnionType : String -> Result String UnionType
createUnionType blob =
    if isUnionType blob then
        { name =
            getUnionTypeName blob
        , fields =
            getUnionTypeFields blob
                |> List.map (\field -> ( field, ResolvedType field ))
                |> Dict.fromList
        }
            |> Ok
    else
        Err "not a union type"


{-|
    >>> getUnionTypeName "type A = B | C"
    "A"
-}
getUnionTypeName : String -> String
getUnionTypeName blob =
    let
        equalIndex =
            String.indexes "=" blob
                |> List.head
                |> Maybe.withDefault -1
    in
        String.slice 4 equalIndex blob
            |> String.trim


{-|
    >>> getUnionTypeFields "type A = B | C"
    ["B", "C"]
-}
getUnionTypeFields : String -> List String
getUnionTypeFields blob =
    String.toList blob
        |> List.Extra.dropWhile ((/=) '=')
        |> List.drop 1
        |> String.fromList
        |> String.split "|"
        |> List.map String.trim
