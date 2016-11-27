#!/usr/bin/env node

var Elm = require('./elm.js');

var elm = Elm.Main.worker({ configFile: "./elm-lint-conf.json" });
