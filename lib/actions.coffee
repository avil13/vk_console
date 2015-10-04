module.exports = (ScreenBlocks)->

    vk = require('./vk.coffee')
    settings = require('./screen_settings.coffee')()
    os = require('os')
    exec = require('exec')
    notifier = require('node-notifier')

    vk.checkToken()

    message_id = 0 #// переменная для хранения ID беседы
    can_read = false #// Разрешение на отметку сообщений как прочитанных
    count_unread_msg = 0 #// количество не прочтенных сообщений


    @unreadCount