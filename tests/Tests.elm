module Tests exposing (..)

import Test exposing (..)
import Expect
import Fuzz exposing (list, int, tuple, string)
import String
import Doc.Tests


all : Test
all =
    Doc.Tests.all
