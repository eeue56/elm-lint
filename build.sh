#! /bin/bash -ex
bin_dir="./node_modules/.bin/"

$bin_dir/elm-make src/Main.elm --output bin/elm.js

