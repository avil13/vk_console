open = require('open')
vk = require 'VK'
token = require('token')
express = require('express')
clc = require 'cli-color'
app = express()
friends = []
ids = []


# Список аргументов
arg = process.argv.slice 2


#
sqlite3 = require('sqlite3').verbose()
db = new sqlite3.Database('mydb.db')

db.each "SELECT user, friend, rating FROM user_friend ORDER BY rating DESC", (err, row)->
    friends.push(row)
    ids.push(row.friend)
    #
friendName = (user_ids)->
    obj =
        user_ids: user_ids.join(',')
        fields:'photo_50'
        name_case: 'Nom'
        v:5.29
    vk.request 'users.get', obj, (data)->
                fr = {}
                if data && data.response
                    for v in data.response
                        fr[v.id] =
                            name: "#{v.first_name} #{v.last_name}"
                            photo: v.photo_50
                    for f, i in friends
                        friends[i]['name'] = fr[f.friend].name if fr[f.friend]
                        friends[i]['photo'] = fr[f.friend].photo if fr[f.friend]

# # #

getFriendName = ->
    len = Math.ceil(ids.length / 3)
    i = 0
    while i < 3
        friendName(ids.slice((i*len), (++i*len)))


# # #

runServer = ->
    app.set('views', './views')
    app.set('view engine', 'jade')
    app.use '/template', express.static(__dirname + '/views/public/template/')
    app.use '/css/', express.static(__dirname + '/views/public/css/')
    app.use '/js', express.static(__dirname + '/views/public/js/')
    app.use '/maps', express.static(__dirname + '/views/public/maps/')

    app.post '/api/:action/:date1?/:date2?', (req, res)->
        result = {}
        # список API методов для работы
        actions =
            friends: ->
                result.content = friends
                res.json result
            is_runing: ->
                result.status = true
                res.json result

        # выполняем экшен
        if actions[req.params.action] then do actions[req.params.action]
        # console.log req.params


    app.get '/', (req, res)-> res.render 'index', {friends: []}

    server = app.listen 3000, ->
        host = server.address().address
        port = server.address().port
        console.log(clc.green("app listening at http://#{host}:#{port}"))
        # если передан параметр single то не открываем окно в браузере
        if !(arg.indexOf('single') > -1) then open("http://#{host}:#{port}")



###
# поиск фото
###



setTimeout getFriendName, 300
setTimeout runServer, 900

