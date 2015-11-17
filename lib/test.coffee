# vk       = require('./vk.coffee')
settings = require('./screen_settings.coffee')
action   = require('./actions.coffee')
blessed  = require('blessed')
h        = require('./helper.coffee')

ScreenBlocks = {}
ScreenBlocks.txt =
ScreenBlocks.nav =
ScreenBlocks.stat =
ScreenBlocks.messages =
ScreenBlocks.FriendList =
        focus: ->
        setItems: ->
        setScrollPerc: ->
        parent:
            render: ->
        add: (el)-> console.log el
        setContent: (data)-> console.log data

# Actions = require('./actions.coffee')(ScreenBlocks)
Singletone = do ->
    instance = null
    Construct_singletone = ->
        if instance then return instance
        if this and @constructor == Construct_singletone
            instance = this
        else
            return new Construct_singletone
        return
    Construct_singletone


# # # # # #


h.setScreen ScreenBlocks

# vk.r 'messages.getDialogs', {}, console.log
# vk.checkToken (data)-> console.log "OK!! ==> #{data}"

# action.setConf {message_id:6866606, is_chat: no}
# action.getHistory console.log

# mess = {"items": [{"id": 200560, "body": "Я тогда вечером зайду ок", "user_id": 6866606, "from_id": 6866606, "date": 1447654849, "read_state": 1, "out": 0 }, {"id": 200559, "body": "У самого так же", "user_id": 6866606, "from_id": 19230273, "date": 1447654834, "read_state": 1, "out": 1 }]}
# h.historyList mess

# console.log(action.getConf())

# action.send('Не обращайте внимания на это сообщение', console.log)

# id = h.getID 'иванов иван __u_123456789__'
# console.log id


action.usersGet 205387401
setTimeout (->
     console.log h.friend 205387401
    ), 2000