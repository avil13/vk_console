nn = require('node-notifier')
friendName = []


module.exports = do ->

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
        for v in arr
            if typeof v == 'object'
                str = "#{if v.out == 1 then '»' else '«'} #{v.body} \t\t\t"
                str += if v.chat_id? then "chat__#{v.chat_id}" else "uid__#{v.uid}"
                if v.read_state == 1 then str = "{red-fg}#{str}{/red-fg}"
                res.push str
        res
