vk = require('./vk.coffee')
settings = require('./screen_settings.coffee')()
h = require './helper.coffee'


module.exports = (ScreenBlocks)->
    vk.checkToken() # проверяем токен

    message_id = 0 #// переменная для хранения ID беседы
    can_read = false #// Разрешение на отметку сообщений как прочитанных
    count_unread_msg = 0 #// количество не прочтенных сообщений

    messages = (str = [])->
        if typeof str == 'object'
            str = JSON.parse str
        ScreenBlocks.messages.setContent(str)
        ScreenBlocks.messages.parent.render()
    friendList = (arr)->
        ScreenBlocks.FriendList.setItems([])
        for v in arr then ScreenBlocks.FriendList.add(v)
        ScreenBlocks.FriendList.parent.render()

    do ->
        # Список сообщений включая беседы
        getDialogs: (offset = 0)->
            options =
                offset: offset
                preview_length: 10
                count: settings.f_count
            vk.request 'messages.getDialogs', options, (obj)->
                if obj
                    list = h.friendList(obj)
                    friendList(list)
                else
                    friendList(['Error...'])


        # получение беседы

        # отправка сообщений

        #
        #