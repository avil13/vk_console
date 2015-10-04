###
#
###

vk = require 'VK'
clc = require 'cli-color'
token =  require 'token'


###
#  объект запроса к серверу
###

console.log(clc.blue.bgGreen.bold('   Watch for user:', token.w_u, '   '))


sqlite3 = require('sqlite3').verbose()
db = new sqlite3.Database('friend_db.db')

db.run("CREATE TABLE if not exists friends (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,
                                        `watch_user` INT,
                                        `user` INT,
                                        `date` TEXT)")



# # #
date = new Date()


#
# получаем массив id друзей из БД
# получаем данные с сервера
# сравниваем количество, если оно разниться, то добавляем нового с датой и выводим его имя в консоль
list_friends = []
db.serialize  ->
    db.run "SELECT count(*) FROM `friends` WHERE `watch_user`=#{token.w_u}", (err, row)->
        console.log '->', row
        if row
            db.each "SELECT `user` FROM `friends` WHERE `watch_user`=#{token.w_u}", (err, row)->
                list_friends.push row.user

# do FriendsList

friendServe = ->
    obj =
        user_id: token.w_u
        order: 'hints'
        v:5.29
    vk.request 'friends.get', obj, (data)->
                if data && data.response
                    stmt = db.prepare("INSERT INTO friends (watch_user, user, date) VALUES (?, ?, ?)")
                    for v in data.response.items
                        if !(list_friends.indexOf(v) > -1)
                            stmt.run([token.w_u, v, date])
                            console.log clc.red(v)
                    stmt.finalize()

# # #

setTimeout (->console.log list_friends.length), 1000
# setTimeout friendServe, 1000















