module Rules.Modules exposing (..)

import String
import List.Extra


type alias ModuleConfig a =
    { a
    | badModuleNames : List String
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
    >>> isBadImport { badModuleNames = ["a"] } "a"
    True

    >>> isBadImport { badModuleNames = ["a", "b"] } "b"
    True

    >>> isBadImport { badModuleNames = ["a"] } "b"
    False
-}
isBadImport : ModuleConfig a -> String -> Bool
isBadImport { badModuleNames } name =
    List.member name badModuleNames

{-|
   >>> badModules { badModuleNames = ["a", "b"] } [ "import a", "import c" ]
   [ "a" ]

   >>> badModules { badModuleNames = ["a", "b"] } [ "import a", "import b" ]
   [ "a", "b" ]

   >>> badModules { badModuleNames = ["a", "b"] } ["a", "junk", "import acdf" "import a", "import b"]
   [ "a", "b" ]
-}
badModules : ModuleConfig a -> List String -> List String
badModules config =
    List.Extra.takeWhile isImport
        >> List.map moduleName
        >> List.filter (isBadImport config)
