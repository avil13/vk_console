###

coffee auction.coffee --max=650 --group=10182695 --post=64293
###

vk = require './lib/vk'
clc = require 'cli-color'
argv = require('yargs')
        .example '$0 -p=64293'
        .help 'h'
        .alias 'h', 'help'
        .options 'm',
            alias: 'max'
            default: 250
            describe: 'Максимальная ставка'
            type: 'number'
            demand: no
        .options 'g',
            alias: 'group'
            default: 10182695
            describe: 'id Группы'
            type: 'number'
            demand: no
        .options 'p',
            alias: 'post'
            describe: 'id записи'
            type: 'number'
            demand: on
            demand: no
        .options 't',
            alias: 'timeout'
            default: 2.5
            describe: 'Секунды между проверками'
            type: 'number'
            demand: no
        .argv

vk.checkToken (user)->
    user = user.pop()
    time = do -> # время когда остановится проверка 00:01 слейдующего дня
        d = new Date
        d.setHours(23)
        d.setMinutes(59)
        d.setSeconds(59)
        d.getTime() + (1000 * 60)
    sendData =
        owner_id: "-#{argv.g}"
        post_id: argv.p
        need_likes: 0
        offset: 0
        count: 1
        sort: 'desc'
    currentBet = 0 # последняя ставка

    # метод проверки времени
    check = ->
        if !sendData.post_id || sendData.owner_id >= 0
            console.log clc.bgRedBright "Не верны параметры запросса [group:#{sendData.owner_id}][post:#{sendData.post_id}]"
            do process.exit
        if time < Date.now()
            console.log clc.bgRedBright "Закончилось время аукциона"
            do process.exit

    # проверка ставки
    checkBet = (last_comment, callback)->
        if last_comment.from_id == user.id
            process.stdout.write '.'
            return false # наша ставка последняя
        bet = parseInt(last_comment.text, 10)
        if isNaN(bet) then return console.log clc.blue 'Проверте комментарии'
        if bet <= currentBet then return console.log "ставка ниже последней"
        if bet < argv.m
            callback(++bet)
        else
            console.log clc.red "К сожалению нашу максимальную ставку '#{argv.max}' переплюнули: '#{bet}'"
            do process.exit

    # Запрос к странице
    new_query = ->
        do check
        vk.pr('wall.getComments', sendData)
            .then (data)->
                setTimeout new_query, argv.t * 1000
                checkBet data.items.pop(), (bet)->
                    currentBet = bet
                    sendData['text'] = "#{bet}"
                    # делаем еще одну ставку
                    vk.req 'wall.addComment', sendData, (data)-> console.log clc.cyan "Еще одна ставка #{bet}"
            .catch (err)->
                setTimeout new_query, argv.t * 1000
                console.log clc.red err

    # Start
    vk.pr 'groups.getById', { group_id: argv.g }
        .then (data)->
            console.log "группа: #{clc.cyan (data.pop()).name}"
            do new_query
        .catch (err)->
            console.log clc.red 'Группа не найдена'
