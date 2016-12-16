module Rules.Modules exposing (..)

import String
import List.Extra
import Dict exposing (Dict)


type alias ModuleConfig a =
    { a
        | badModules : Dict String String
    }


{-|
    >>> isImport "import Name"
    True

    >>> isImport "module Rules.Modules exposing (..)"
    False
-}
isImport : String -> Bool
isImport =
    String.startsWith "import "


{-|
    >>> moduleName "import Name"
    "Name"

    >>> moduleName "import Name exposing (..)"
    "Name"

    >>> moduleName ""
    ""
-}
moduleName : String -> String
moduleName =
    String.dropLeft 7
        >> String.trim
        >> String.split " "
        >> List.head
        >> Maybe.withDefault ""


{-|
    >>> import Dict exposing (fromList)

    >>> isBadImport { badModules = fromList [("a", "")] } "a"
    True

    >>> isBadImport { badModules = fromList [("a", ""), ("b", "")] } "b"
    True

    >>> isBadImport { badModules = fromList [("a", "")] } "b"
    False
-}
isBadImport : ModuleConfig a -> String -> Bool
isBadImport { badModules } name =
    List.member name (Dict.keys badModules)


{-|
    >>> import Dict exposing (fromList)

    >>> badModules { badModules = fromList [("a", ""), ("b", "")] } [ "import a", "import c" ]
    [ "a" ]

    >>> badModules { badModules = fromList [("a", ""), ("b", "")] } [ "import a", "import b" ]
    [ "a", "b" ]

    >>> badModules { badModules = fromList [("a", ""), ("b", "")] } ["a", "junk", "import acdf", "import a", "import b"]
    [ "a", "b" ]
-}
badModules : ModuleConfig a -> List String -> List String
badModules config =
    List.filter isImport
        >> List.map moduleName
        >> List.filter (isBadImport config)


{-|
    >>> import Dict exposing (fromList)

    >>> suggestImprovement { badModules = fromList [ ("a", "a is bad because") ] } "a"
    Just "a is bad because"

    >>> suggestImprovement { badModules = fromList [ ("a", "a is bad because") ] } "b"
    Nothing
-}
suggestImprovement : ModuleConfig a -> String -> Maybe String
suggestImprovement config moduleName =
    Dict.get moduleName config.badModules


{-|
    >>> import Dict exposing (fromList)

    >>> suggestImprovements { badModules = fromList [ ("a", "a is bad because") ] } ["import a"]
    ["a is bad because"]

    >>> suggestImprovements { badModules = fromList [ ("a", "a is bad because") ] } ["import b"]
    []
-}
suggestImprovements : ModuleConfig a -> List String -> List String
suggestImprovements config =
    List.filter isImport
        >> List.filterMap (suggestImprovement config << moduleName)
