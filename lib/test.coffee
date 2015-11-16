vk = require './vk.coffee'
settings = require './screen_settings.coffee'
action = require './actions.coffee'
blessed = require 'blessed'
h = require './helper.coffee'

ScreenBlocks =
    txt:
        focus: ->
    messages:
        focus: ->
        setContent: (data)->
            console.log data
        parent:
            render: ->
        setScrollPerc: ->
    FriendList:
        focus: ->
        add: (el)-> console.log el
        setItems: ->
        parent:
            render: ->

# Actions = require('./actions.coffee')(ScreenBlocks)


# # # # # #


h.setScreen ScreenBlocks

# vk.r 'messages.getDialogs', {}, console.log
# vk.checkToken (data)-> console.log "OK!! ==> #{data}"

# action.setConf {message_id:6866606, is_chat: no}
# action.getHistory console.log
mess = {"items": [{"id": 200560, "body": "Я тогда вечером зайду ок", "user_id": 6866606, "from_id": 6866606, "date": 1447654849, "read_state": 1, "out": 0 }, {"id": 200559, "body": "У самого так же", "user_id": 6866606, "from_id": 19230273, "date": 1447654834, "read_state": 1, "out": 1 }]}
h.historyList mess


# console.log(action.getConf())

# action.send('Не обращайте внимания на это сообщение', console.log)

# id = h.getID 'иванов иван __u_123456789__'
# console.log id
