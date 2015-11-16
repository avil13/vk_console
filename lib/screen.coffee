vk       = require './vk.coffee'
settings = require './screen_settings.coffee'
action   = require './actions.coffee'
blessed  = require 'blessed'
h        = require './helper.coffee'

vk.checkToken ->
    screen = blessed.screen()
    settings = require('./screen_settings.coffee')(screen)

    ScreenBlocks = {}
    ScreenBlocks.FriendList = blessed.List(settings.FriendList)
    ScreenBlocks.messages = blessed.Box(settings.messages)
    # // поле ввода
    ScreenBlocks.txt = blessed.Textarea(settings.txt)
    ScreenBlocks.box = blessed.box(settings.box)
    ScreenBlocks.nav = blessed.box(settings.nav)
    screen.render()

    h.setScreen ScreenBlocks # передача объекта экрана

    # выход
    ScreenBlocks.FriendList.key ['escape'], (ch, key)-> process.exit(0)

    # перемещение по окнам
    screen.key ['t', 'T', 'е', 'Е'], (ch, key)-> ScreenBlocks.txt.focus()
    screen.key ['f', 'F', 'а', 'А'], (ch, key)-> ScreenBlocks.FriendList.focus()
    screen.key ['r', 'R', 'к', 'К'], (ch, key)-> ScreenBlocks.messages.focus()
    # // ******** focuses ********
    ScreenBlocks.FriendList.on 'focus', ->
        action.getDialogs(h.friendList) # списко друзей слева
        ScreenBlocks.box.setContent "{bold}Active:{/bold} Friend list [F]"
        screen.render()

    ScreenBlocks.txt.on 'focus', ->
        ScreenBlocks.box.setContent "{bold}Active:{/bold} Text write [T]"
        screen.render()

    ScreenBlocks.messages.on 'focus', ->
        # Actions.messageAsReadest()
        # Actions.getHistory()
        ScreenBlocks.box.setContent "{bold}Active:{/bold} Read message [R]"
        screen.render()
    # // ********
    action.getDialogs h.friendList # списко друзей слева

    # Выбор диалога для беседы
    ScreenBlocks.FriendList.on 'select', (index)->
        if index && index.content
            id = h.getID(index.content)
            if id?
                action.setConf id
                action.getHistory h.historyList
        else
            console.log index, 'select error'





