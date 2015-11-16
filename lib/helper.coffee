nn = require('node-notifier')
vk = require('./vk.coffee')
friend_name = {}
empty_ids = []

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


module.exports = do ->

    # список друзей
    Friend = (id)->
        if friend_name[id]?
            friend_name[id]
        else
            empty_ids.push id

        setTimeout (->
                if empty_ids.length > 0
                    vk.request 'users.get', {user_ids:empty_ids.join(','), name_case:'Nom'}, (data)->
                        for f in data.items
                            friend_name[f.id] = "#{f.first_name} #{f.last_name}"
                        empty_ids = []
            ), 1000
        if friend_name[id]? then friend_name[id] else id

    friendList: (arr)->
        res = []
        if arr.items?
            for v in arr.items
                if typeof v == 'object' && v.message?
                    m = v.message
                    str = "#{Friend(m.user_id)}"
                    str += "#{if m.out == 1 then '»' else '«'} #{m.body} \t\t\t "
                    str += if m.chat_id? then "chat__#{m.chat_id}" else "user__#{m.user_id}"
                    if m.read_state == 1 then str = "{red-fg}#{str}{/red-fg}"
                    res.push str
        res

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
            return {id: @int(re_u), is_chat: no}
        re_ch = /__ch_\d+__/g.exec(str) # для ID чата
        if re_ch
            return {id: @int(re_ch), is_chat: on}
        no






