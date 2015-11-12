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

vk.checkToken (data)->
    console.log "OK!! ==> #{data}"

# vk.request 'messages.getDialogs', {}, console.log