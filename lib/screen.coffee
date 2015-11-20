require('./log')
blessed  = require 'blessed'
vk       = require './vk'
action   = require './action'
h        = require './helper'

vk.checkToken ->
    # экран консоли
    screen = blessed.screen()
    settings = require('./screen_settings.coffee')(screen)

    ScreenBlocks = {}
    ScreenBlocks.FriendList = blessed.List(settings.FriendList)
    ScreenBlocks.messages = blessed.Box(settings.messages)
    # // поле ввода
    ScreenBlocks.txt = blessed.Textarea(settings.txt)
    ScreenBlocks.box = blessed.box(settings.box)
    ScreenBlocks.stat = blessed.box(settings.stat)
    ScreenBlocks.nav = blessed.box(settings.nav)
    # screen.render()

    # передача объекта экрана
    h.setScreen ScreenBlocks
    # определение метода для имен пользователя
    h.usersGet = action.usersGet.bind null, h.friend_save.bind(h), h.errorStat.bind(h)
    h.getChat = action.getChat.bind null, h.chat_save.bind(h), h.errorStat.bind(h)

    # # # # # # # # # # # # # # # # # # # # # # #
    # Создание функций для работы с сообщениями #
    getDialogs = action.getDialogs.bind null, h.friendList.bind(h), h.errorStat.bind(h)
    getHistory = action.getHistory.bind null, h.historyList.bind(h), h.errorStat.bind(h)
    # getDialogs = h.defer getDialogs
    # getHistory = h.defer getHistory

    # выход # # # # # # # # # # # # # # # # # # #
    ScreenBlocks.FriendList.key ['escape'], (ch, key)-> process.exit(0)
    ScreenBlocks.messages.key ['escape'], (ch, key)-> ScreenBlocks.FriendList.focus()
    ScreenBlocks.txt.key ['escape'], (ch, key)-> ScreenBlocks.FriendList.focus()

    # перемещение по окнам # # # # # # # # # # # #
    screen.key ['t', 'T', 'е', 'Е'], (ch, key)-> ScreenBlocks.txt.focus()
    screen.key ['f', 'F', 'а', 'А'], (ch, key)-> ScreenBlocks.FriendList.focus()
    screen.key ['r', 'R', 'к', 'К'], (ch, key)-> ScreenBlocks.messages.focus()

    # // ******** focuses ********
    ScreenBlocks.FriendList.on 'focus', ->
        do getDialogs # списко друзей слева
        ScreenBlocks.box.setContent "{bold}Active:{/bold} Friend list [F]"
        screen.render()

    ScreenBlocks.txt.on 'focus', ->
        do getHistory
        ScreenBlocks.box.setContent "{bold}Active:{/bold} Text write [T]"
        screen.render()

    ScreenBlocks.messages.on 'focus', ->
        do getHistory
        ScreenBlocks.box.setContent "{bold}Active:{/bold} Read message [R]"
        screen.render()
    # * * * focus
    ScreenBlocks.FriendList.focus()

    # Выбор диалога для беседы # # # # # # # # # # #
    ScreenBlocks.FriendList.on 'select', (index)->
        if index && index.content
            id = h.getID(index.content)
            if id?
                action.setConf id
                do getHistory
                if id.is_chat
                    ScreenBlocks.stat.setContent h.chat id.message_id
                ScreenBlocks.txt.focus()
        else
            h.errorStat index.content





# setTimeout (-> process.exit(0)), 5000