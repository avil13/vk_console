clc = require 'cli-color'

# color
(global || GLOBAL).log = (msg, error=false, exit=false)->
    console.log process.argv[1], "\n"
    msg = JSON.stringify msg if typeof msg == 'object'
    if error
        console.trace clc.red msg
    else
        console.log clc.green msg
    if exit then process.exit 0
