###
# audio.get     - Возвращает список аудиозаписей пользователя или сообщества.
# audio.getCount - Возвращает количество аудиозаписей пользователя или сообщества.
# audio.getBroadcastList - Возвращает список друзей и сообществ пользователя, которые транслируют музыку в статус
#
# проверять свои записаи если нет, то начинать сканировать друзей кэшируя списки записей в бд
###

vk = require 'VK'
clc = require 'cli-color'
token =  require 'token'

fs = require('fs')

log = (obj={})->
    obj = JSON.stringify obj
    fs.writeFile "#{__dirname}/req.log", obj, (err)->
        if err then return console.log(err)
        console.log("The file was saved!")

###
есть два режима работы
2) с параметром на сканирование 'scan' ___
если есть идем дальше
получаем список друзей включая в него и самого пользователя
проверяем задан ли параметр на пересканирование песен
сканируем все аудиозаписи пользователей занося их БД
1) по умеолчанию ___
првоеряем есть ли доступ к тарнсляции песен пользователя
запускаем проверку играющей песни по интервалу,
если песня есть то проверяем у каких бользователей в БД она есть
###

###
# song_list
`id`        INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
`user`      INT     пользователь
`song`      TEXT    название песни
###
sqlite3 = require('sqlite3').verbose()
db = new sqlite3.Database('music_db.db')
db.run("CREATE TABLE if not exists song_list (
    `id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    `user` INT,
    `title` TEXT,
    `artist` TEXT
    )")
# db.run("DELETE FROM song_list")

# создаем массив пользователей
users = []
users.push(token.w_u)



# запись списка песен в БД
writeSongs = (user_id, songs)->
    stmt = db.prepare("INSERT INTO song_list (user, title, artist) VALUES (?, ?, ?)")
    for s in songs
        stmt.run(user_id, s.title, s.artist)
    stmt.finalize()
    db.close()

# получение песен пользователя
songList = (user_id)->
    opt =
        owner_id: user_id
        need_user: 0
        offset: 0
        count: 100
        version: 5.29
    vk.request 'audio.get', opt, (data)->
        log(data)
        debugger
        # console.log data.response.length
        # writeSongs(user_id, data.response) if data && data.response

# проходим по списку пользователей
runScan = (users)->
    for user_id in users
        songList(user_id)


#
# vk.request 'friends.get', {user_id: token.w_u, version: 5.29}, (data)->
#     users.push(data.response) if data && data.response




# # #
arg = process.argv.slice 2

# setTimeout (->runScan(users)), 10000
runScan(users)
# if arg.indexOf('scan') > -1
#     console.log clc.green('do scan music')
# else
#     console.log clc.yellow('not do scan music')

