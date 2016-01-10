###

coffee auction.coffee --max=650 --group=10182695 --post=64293
coffee auction.coffee --max=650 --url=http://vk.com/muzkomissionka?w=wall-10182695_75349
###

vk = require './lib/vk'
clc = require 'cli-color'
argv = require('yargs').argv

vk.checkToken (user)->
    user = user.pop()
    #
    if !argv.group && !argv.post && !argv.url
        console.log """
        #{clc.cyan('Список параметров которые можно передать для работы:')}
        #{clc.green('--max')}     Максимальная ставка [300]
        #{clc.green('--group')}   id записи
        #{clc.green('--post')}    id группы
        #{clc.green('--url')}     URL до комментария на стене
        #{clc.green('--timeout')} Время между запросами [2500]
        Все ставки будут вестись до 00:01 слейдующего дня
        """
        return false
    #
    options =
        group:   parseInt(argv.group)   || 0       # группа
        post:    parseInt(argv.post)    || 0       # запись
        max:     parseInt(argv.max)     || 300     # Максимальная ставка
        timeout: parseInt(argv.timeout) || 2500    # время между проверками
        time: do -> # время когда остановится проверка 00:01 слейдующего дня
            d = new Date
            d.setHours(23)
            d.setMinutes(59)
            d.setSeconds(59)
            d.getTime() + (1000 * 60)
    #

    if argv.url && !argv.post && !argv.group
        myRe = /wall-(\d+)_(\d+)/g
        myArray = myRe.exec(argv.url)
        options.group = myArray[1]
        options.post = myArray[2]
        if !options.post && !options.group
            console.log clc.red 'Не найдена группа или запись'
            return false

    # даныне для запроса
    options.max = parseInt options.max, 10
    sendData =
        owner_id: "-#{parseInt(options.group, 10)}"
        post_id: options.post
        need_likes: 0
        offset: 0
        count: 1
        sort: 'desc'

    # метод проверки времени
    check = ->
        if !sendData.post_id || sendData.owner_id >= 0
            console.log clc.bgRedBright "Не верны параметры запросса [group:#{sendData.owner_id}][post:#{sendData.post_id}]"
            do process.exit
        if options.time < (new Date).getTime()
            console.log clc.bgRedBright "Закончилось время аукциона"
            do process.exit

    # проверка ставки
    checkBet = (last_comment, callback)->
        if last_comment.from_id == user.id
            return false # наша ставка последняя
        bet = parseInt(last_comment.text.replace(/\D+/g,""), 10)
        if bet < options.max
            callback(++bet)
        else
            console.log clc.red "К сожалению нашу максимальную ставку '#{options.max}' переплюнули: '#{bet}'"
            do process.exit

    # Запрос к странице
    query = ->
        do check
        vk.req 'wall.getComments', sendData, (data)->
            checkBet data.items.pop(), (bet)->
                sendData['text'] = "#{bet}"
                # делаем еще одну ставку
                vk.req 'wall.addComment', sendData, (data)-> console.log clc.cyan "Еще одна ставка #{bet}"


    # повторяем запрос через заданный промежуток времени
    setInterval query, options.timeout












    #

