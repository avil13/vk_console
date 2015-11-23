nn    = require 'node-notifier'
cache = require './cache'

# # # # переменные для обработки особенностей скрипта
config =
    ScreenBlocks: null
    timer: {} # defer
    args: {} # defer
    friend: {} # message name
    chat: {} # message name
    msg_id: 0 # id последнего сообщения, глядя на него будем смотреть стоит ли обновлять


helper =
    # всплывающее сообщение
    msg: (str = " ", title = "Сообщение" )->
        nn.notify
            title: title
            message: str
            icon: "#{__dirname}/../icon.png"
            sound: true

    # получение параметра url
    url_param: (str, param)->
        if str && str.split("#{param}=")[1]
            return str.split("#{param}=")[1].split('&')[0]
        return false

    # проверка аргументов переданных при запуске
    # возвращает либо массив параметров, либо проверяет есть ли название параметра среди переданных
    arg: (param)->
        arg = process.argv.slice(2)
        return arg unless param
        return arg.indexOf("#{param}") > -1

    # ten number
    t: (d)-> if d < 10 then "0#{d}" else "#{d}"

    # date
    date: (date)->
        d = new Date(date * 1000)
        "#{@t(d.getHours())}:#{@t(d.getMinutes())} #{@t(d.getDate())}.#{@t(d.getMonth()+1)}.#{d.getFullYear()}"

    extend: (old_obj, new_obj)->
        for own k, v of new_obj
            if typeof v == 'object' && v != undefined
                @extend(old_obj[k], v)
            else
                old_obj[k] = new_obj[k] || old_obj[k]
        old_obj

    # получение числа
    int: (str)-> parseInt("#{str}".replace(/\D+/g," "), 10) || 0

    # получение ID пользователя или чата
    getID: (str)->
        re_u = /__u_\d+__/g.exec(str) # для ID пользователя
        if re_u
            @errorStat re_u
            return {message_id: @int(re_u), is_chat: no}
        re_ch = /__ch_\d+__/g.exec(str) # для ID чата
        if re_ch
            @errorStat re_ch
            return {message_id: @int(re_ch), is_chat: on}
        no

    # # # # # #

    # установка объекта экрана
    setScreen: (scr)-> config.ScreenBlocks = scr

    # # # # # #
    # проверка новых диалогов
    unreadest: (arr)->
        str = ''
        if arr.unread_dialogs?
            if arr.items?
                for v in arr.items
                    if typeof v == 'object' && v.message? && v.unread?
                        m = v.message
                        str += "#{if m.chat_id? then @chat(m.chat_id) else @friend(m.user_id)}\n"
            @msg str


    # список диалогов слева
    friendList: (arr)->
        if config.ScreenBlocks?
            if arr.items?
                list = []
                for v in arr.items
                    if typeof v == 'object' && v.message?
                        m = v.message
                        str = "#{if m.chat_id? then @chat(m.chat_id) else @friend(m.user_id)} "
                        str += "#{if m.out == 1 then '»' else '«'} #{m.body} \t\t\t "
                        str += if m.chat_id? then "__ch_#{m.chat_id}__" else "__u_#{m.user_id}__"
                        if m.read_state != 1 then str = "{red-fg}#{str}{/red-fg}"
                        list.push str
            if cache.check('message', list)
                if cache.check('unreadest', arr)
                    @unreadest arr # если есть непрочитанные то сообщаем об этом
                config.ScreenBlocks.FriendList.setItems([])
                for s in list then config.ScreenBlocks.FriendList.add(s)
                config.ScreenBlocks.FriendList.parent.render()

    # история сообщений выбранной беседы
    historyList: (arr)->
        if config.ScreenBlocks?
            content = []
            if arr.items?
                for v in arr.items.reverse()
                    content.push "{bold}#{@friend(v.from_id)}{/bold} #{@date(v.date)}"
                    content.push v.body
                    content.push @attach(v) if v.attachments?
                    content.push "\n"
            content = content.join("\n")
            if cache.check('history', content)
                config.ScreenBlocks.messages.setContent(content)
                config.ScreenBlocks.messages.setScrollPerc(100)
                config.ScreenBlocks.messages.parent.render()

    # вложения
    attach: (el, red = true)->
        arr = []
        if el.attachments?
            arr.push "{red-fg}✪ ✪ ✪ attach ✪ ✪ ✪" if red
            for v in el.attachments
                if v.type == 'link' then arr.push v.link.url
                if v.type == 'photo' then arr.push v.photo.photo_604
                if v.type == 'video'
                    arr.push "== video =="
                    arr.push v.video.title

                if v.type == 'wall'
                    if v.wall.text? then arr.push v.wall.text
                    if v.wall.attachments? then @attach(v.wall.attachments, false)

                if v.type == 'audio'
                    arr.push "= ♪ ♫ ♪ ♫ ♪ ="
                    arr.push "{bold}#{v.audio.artist}{/bold} #{v.audio.title}"

            arr.push "{/red-fg}" if red
        arr.join "\n"

    # Описание ошибки
    errorStat: (err='')->
        err = err.error && err.error.error_msg || err
        # err = Object.keys err
        if config.ScreenBlocks?
            config.ScreenBlocks.stat.setContent("==> #{err}")
            config.ScreenBlocks.stat.parent.render()

    # выполнение функции не чаще чем за указанный период времени
    defer: (func, delay = 1000)->
        ->
            context = this
            unless config.args["#{func}"]
                config.args["#{func}"] = []
            config.args["#{func}"].push [].slice.call(arguments)

            clearTimeout config.timer["#{func}"] || 0
            config.timer["#{func}"] = setTimeout (->
                    func.apply(context, config.args[func])
                    config.args[func] = []
                ), delay

    # #сохранение имени
    friend_save: (arr)->
        for v in arr
            if v.first_name? && v.last_name?
                config.friend[v.id] = "#{v.first_name} #{v.last_name}"

    # метод для отправки запроса для получения имен пользователей
    usersGet: no
    # метод для отправки запроса для получения названий чатов
    getChat: no

    # получение имени друга
    friend: (id)->
        return config.friend[id] if config.friend[id]
        if @usersGet? then @defer(@usersGet)(id)
        id

    # сохранение названий чатов
    chat_save: (arr)->
        for v in arr
            if v.title?
                config.chat[v.id] = "{bold}#{v.title}{/bold}"

    # получение имени чата
    chat: (id)->
        return config.chat[id] if config.chat[id]
        if @getChat? then @defer(@getChat)(id)
        id

# ===
module.exports = helper