var loadJson = function(filename) {
    var data = null;

    try{
        data = require(filename);
    } catch (e) {
        return { 'ctor': 'Err', _0: e.message };
    }
    return { 'ctor': 'Ok', _0: data };
};


var _eeue56$elm_lint$Native_IO = {
    loadJson: loadJson,
    currentDir: process.cwd()
};
