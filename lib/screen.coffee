vk = require './vk.coffee'
settings = require './screen_settings.coffee'
action = require './actions.coffee'
blessed = require 'blessed'
h = require './helper.coffee'

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
    screen.render();

    # выход
    ScreenBlocks.FriendList.key ['escape'], (ch, key)-> process.exit(0)

    # Экшены для работы
    Actions = require('./actions.coffee')(ScreenBlocks)



    # // ******** focuses ********
    ScreenBlocks.FriendList.on 'focus', ->
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

    Actions.getDialogs()





