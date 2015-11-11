nn = require('node-notifier')
vk = require('./vk.coffee')
friend_name = {}
empty_ids = []

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

    # всплывающее сообщение
    msg: (str = " ", title = "Сообщение" )->
        nn.notify {
            title: title
            message: str
            icon: "#{__dirname}/../icon.png"
            sound: true
        }

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

    # получение параметра url
    url_param: (str, param)->
        if str && str.split("#{param}=")[1]
            return str.split("#{param}=")[1].split('&')[0]
        return false

