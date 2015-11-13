vk = require('./vk.coffee')
h = require './helper.coffee'
settings = require('./screen_settings.coffee')()

config =
    message_id: 0 #// переменная для хранения ID беседы
    is_chat: false # // общаемя в чате или диалоге
    can_read: false #// Разрешение на отметку сообщений как прочитанных
    count_unread_msg: 0 #// количество не прочтенных сообщений


module.exports =
    # Настройки для задания чата по умолчанию
    setConf: (options)-> h.extend config, options

    # получение объекта настроек
    getConf: -> config

    # Список сообщений включая беседы
    getDialogs: (callback, callback_err, offset = 0)->
        options =
            offset: offset
            preview_length: 10
            count: settings.f_count
        vk
        .pr('messages.getDialogs', options)
        .then (obj)->
            if callback? then callback obj
        .catch (e)->
            if callback_err? then callback_err e

    # получение беседы
    getHistory: (callback, callback_err, offset = 0)->
        options =
            offset: offset
            preview_length: 10
            count: settings.f_count

        if config.is_chat
            options.chat_id = config.message_id
        else
            options.user_id = config.message_id

        vk
        .pr('messages.getHistory', options)
        .then (obj)->
            if callback? then callback obj
        .catch (e)->
            if callback_err? then callback_err e

    # отправка сообщений
    send: (text, callback, callback_err)->
        if config.message_id == 0 || text == '' || text == undefined then return false

        options =
            message: text

        if config.is_chat
            options.chat_id = config.message_id
        else
            options.user_id = config.message_id

        vk
        .pr('messages.send', options)
        .then (obj)->
            if callback? then callback obj
        .catch (e)->
            if callback_err? then callback_err e



    #
    #