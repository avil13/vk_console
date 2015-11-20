clc = require 'cli-color'

# color
GLOBAL.log = (msg, error=false, exit=false)->
    console.log process.argv[1], "\n"
    if error
        console.trace clc.red msg
    else
        msg = JSON.stringify msg if typeof msg == 'object'
        console.log clc.green msg
    if exit then process.exit 0
