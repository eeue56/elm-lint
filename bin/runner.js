#!/usr/bin/env node


var Elm = require(__dirname + '/elm.js');

var elm = Elm.Main.worker({ configFile: "./elm-lint-conf.json" });
