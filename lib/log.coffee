clc = require 'cli-color'

# color
GLOBAL.log = (msg, error=false)->
    console.log process.argv[1], "\n"
    if error
        console.trace clc.red msg
    else
        console.log clc.green msg
