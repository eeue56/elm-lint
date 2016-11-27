var _eeue56$elm_lint$Native_IO = function(){

function elmListFromArray(arr) {
    var out = { 'ctor': '[]' };
    for (var i = arr.length; i--; ) {
        out = { 'ctor': '::', _0:arr[i], _1:out };
    }
    return out;
}

function elmListToArray(xs) {
    var out = [];
    while (xs.ctor !== '[]') {
        out.push(xs._0);
        xs = xs._1;
    }
    return out;
}

var loadJson = function(filename) {
    var data = null;

    try{
        data = require(filename);
    } catch (e) {
        return { 'ctor': 'Err', _0: e.message };
    }
    return { 'ctor': 'Ok', _0: data };
};

var pathJoin = function(a, b){
    var path = require('path');

    return path.join(a, b);
};

var glob = function(pattern){
    var glob = require('glob');

    var matches = glob.sync(pattern, {
        absolute: true,
        nodir: true
    });

    return elmListFromArray(matches);
};

var readFile = function(filename){
    var fs = require('fs');

    try {
        return {
            ctor:'Ok',
            _0: fs.readFileSync(filename, "utf-8")
        };
    } catch (e){
        return {
            ctor: 'Err',
            _0: e.message
        };
    }
};

var log = function(message){
    console.log(message);
    return message;
};

return {
    loadJson: loadJson,
    currentDir: process.cwd(),
    pathJoin: F2(pathJoin),
    glob: glob,
    readFile: readFile,
    log: log
};

}();
