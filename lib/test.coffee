vk = require './vk.coffee'
settings = require './screen_settings.coffee'
action = require './actions.coffee'
blessed = require 'blessed'
h = require './helper.coffee'

ScreenBlocks =
    messages:
        setContent: ->
        parent:
            render: ->
    FriendList:
        add: (el)-> console.log el
        setItems: ->
        parent:
            render: ->

# Actions = require('./actions.coffee')(ScreenBlocks)


# # # # # #

# vk.r 'messages.getDialogs', {}, console.log
# vk.checkToken (data)-> console.log "OK!! ==> #{data}"

action.setConf {message_id:84, is_chat: on}

# action.send('Не обращайте внимания на это сообщение', console.log)


