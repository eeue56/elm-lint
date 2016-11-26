#! /bin/bash -ex
bin_dir="./node_modules/.bin/"

$bin_dir/elm-doc-test
$bin_dir/elm-test
