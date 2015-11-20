vk       = require './vk.coffee'
h        = require './helper'
settings = do require './screen_settings'


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
        .then (obj)-> if callback? then callback obj
        .catch (e)-> if callback_err? then callback_err e


    # получение беседы
    getHistory: (callback, callback_err, offset = 0)->
        options =
            offset: offset
            preview_length: 10
            count: settings.history_count

        if !config.message_id then return callback_err "Не выбран диалог #{config.message_id}"

        if config.is_chat
            options.chat_id = config.message_id
        else
            options.user_id = config.message_id

        vk
        .pr('messages.getHistory', options)
        .then (obj)-> if callback? then callback obj
        .catch (e)-> if callback_err? then callback_err e


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
        .then (obj)-> if callback? then callback obj
        .catch (e)-> if callback_err? then callback_err e


    # Возвращает расширенную информацию о пользователях
    usersGet: (callback, callback_err)->
        arg = Array.prototype.splice.call(arguments, 2)
        options = user_ids: arg.join(',')
        vk.pr('users.get', options)
        .then (obj)-> if callback? then callback obj
        .catch (e)-> if callback_err? then callback_err e

    # Возвращает расширенную информацию о пользователях
    getChat: (callback, callback_err)->
        arg = Array.prototype.splice.call(arguments, 2)
        options = chat_ids: arg.join(',')
        vk.pr('messages.getChat', options)
        .then (obj)-> if callback? then callback obj
        .catch (e)-> if callback_err? then callback_err e


