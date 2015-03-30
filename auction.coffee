###
coffee auction.coffee gr=10182695 post=64293 max=650 time=00:01
coffee auction.coffee max=650 time=00:01 url=http://vk.com/club9488175?w=wall-9488175_24%2Fall
coffee auction.coffee max=100 gr=8679781 post=56601
###

VK = require 'VK'
clc = require 'cli-color'
myID =  require 'token'

# время в течении которого проверять записи
upTime = 1500
# переменная говорящая о том что последняя запись наша и в консоль не надо выводить уведомление
lostIsMy = false
# ставка ниже которой не опускаться
min = 1
# Время после которого остановиться
doTime = false
stopTime =
    hour: 0
    minute: 1
    data: do ->
            d = new Date()
            1 + do d.getDate

# проверка времени аукциона
_checkTime = ->
    return false if doTime == false
    d = new Date()
    return (do d.getHours >= stopTime.hour && do d.getMinutes >=  stopTime.minute && do d.getDate >= stopTime.data)

# строку в целое число
int = (str)->
    str += ''
    parseInt(str.replace(/\D+/g,""), 10)

# отображение даты
_date = (date)->
    d = new Date(date * 1000)
    do d.getHours + ':' + do d.getMinutes + '  ' + do d.getDate + '.' + (1 + do d.getMonth) + '.' + do d.getFullYear

_parseUrl = (url)->
    myRe = /wall-(\d+)_(\d+)/g
    myArray = myRe.exec(url)
    options.gr = myArray[1]
    options.post = myArray[2]

_getTime = (str)->
    t = str.split ':'
    if t.length == 2 then doTime = true
    stopTime.hour = int t[0]
    stopTime.minute = int t[1]



# id пользователя
user_id = int myID.user_id

# опции программы
options =
    gr: false
    post: false
    max: false


# плучение параметров для работы>
arg = process.argv.slice 2

for p in arg
    options.gr   = int (p.split '=')[1] if (p.indexOf 'gr=') > -1
    options.post = int (p.split '=')[1] if (p.indexOf 'post=') > -1
    options.max  = int (p.split '=')[1] if (p.indexOf 'max=') > -1
    options.max  = int (p.split '=')[1] if (p.indexOf 'max=') > -1
    _parseUrl p if (p.indexOf 'url=') > -1
    _getTime p  if (p.indexOf 'time=') > -1


###
# Lets Rock
###

# объект для получения комментариев
sendData =
    owner_id: - int(options.gr)
    post_id: options.post
    need_likes: 0
    offset: 0
    count: 1
    sort: 'desc'
    version: 5.28

# объект для написания комментария
bet =
    owner_id: - int(options.gr)
    post_id: options.post



# метод для написания комментария
addComment = (text)->
    bet['text'] = int(text) + 1 + ''
    VK.request 'wall.addComment', bet, (data)->
        min = int bet.text
        if data && data.response && data.response.cid
            console.log clc.green "Предыдущая ставка: #{text}"
        else
            console.log clc.red "Не удалось установить ставку: #{text}"

# вызов колбека проверки коммента
_action = -> setTimeout getComments, upTime


# метод для получения комментариев
getComments = ->
    if do _checkTime
        console.log clc.bgRedBright "Закончилось время аукциона"
        do process.exit

    VK.request 'wall.getComments', sendData, ((data)->
        # получаем данные ответа для работы
        if data && data.response
            res = data.response[1]
        else
            do _action
            return console.log clc.red 'Error response'

        # если последняя ставка была наша то ничего не делаем
        if res.uid == user_id
            console.log clc.green "Твоя ставка последняя: #{_date(res.date)}" if not lostIsMy
            lostIsMy = true
            return do _action
        else
            lostIsMy = false

        # проверяем является ли сообщение ставкой
        if int(res.text) > 1
            if options.max > int(res.text)
                addComment int(res.text) if min < int(res.text)
            else
                console.log clc.red "Ставка была превышена: #{int(res.text)}"
                do process.exit

        # loop
        do _action
        ),
        -> do _action

# запускаем программу
do getComments








