nn = require('node-notifier')
action   = require './actions.coffee'


# # # # переменные для обработки особенностей скрипта
config =
    ScreenBlocks: null
    friend: {}
    chat: {}
    timer: {}
    args: {}


module.exports =
    # всплывающее сообщение
    msg: (str = " ", title = "Сообщение" )->
        nn.notify {
            title: title
            message: str
            icon: "#{__dirname}/../icon.png"
            sound: true
        }

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

    # список диалогов слева
    friendList: (arr)->
        if config.ScreenBlocks?
            config.ScreenBlocks.FriendList.setItems([])
            if arr.items?
                for v in arr.items
                    if typeof v == 'object' && v.message?
                        m = v.message
                        str = "#{m.user_id} #{if m.out == 1 then '»' else '«'} #{m.body} \t\t\t "
                        str += if m.chat_id? then "__ch_#{m.chat_id}__" else "__u_#{m.user_id}__"
                        if m.read_state != 1 then str = "{red-fg}#{str}{/red-fg}"
                        config.ScreenBlocks.FriendList.add(str)
            config.ScreenBlocks.FriendList.parent.render()

    # история сообщений выбранной беседы
    historyList: (arr)->
        if config.ScreenBlocks?
            content = ''
            config.ScreenBlocks.stat.setContent('')
            if arr.items?
                for v in arr.items
                    content += "{bold}#{v.from_id}{/bold} #{@date(v.date)}\n #{v.body}\n\n"
                content = content.replace(/\n+$/, '')
            config.ScreenBlocks.messages.setContent(content)
            config.ScreenBlocks.messages.setScrollPerc(100)
            config.ScreenBlocks.messages.parent.render()

    # Описание ошибки
    errorStat: (err='')->
        err = err.error && err.error.error_msg || err
        # err = Object.keys err
        if config.ScreenBlocks?
            config.ScreenBlocks.stat.setContent("==> #{err}")
            config.ScreenBlocks.stat.parent.render()

    # выполнение функции не чаще чем за указанный период времени
    throttle: (func, delay = 1000)->
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

    #сохранение имени
    friend_save: (arr)->
        for v in arr
            if v.first_name && v.last_name
                config.friend[v.id] = "#{v.first_name} #{v.last_name}"

    # получение имени друга
    friend: (id)->
        return config.friend[id] if config.friend[id]
        if callback?
            @throttle(action.usersGet)(id)
