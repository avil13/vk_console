open = require('open')
vk = require 'VK'
token = require('token')
express = require('express')
clc = require 'cli-color'
app = express()
friends = []
ids = []

#
sqlite3 = require('sqlite3').verbose()
db = new sqlite3.Database('mydb.db')

db.each "SELECT user, friend, rating FROM user_friend ORDER BY rating DESC", (err, row)->
    friends.push(row)
    ids.push(row.friend)
    #
friendName = ->
    obj =
        user_ids: ids.join(',')
        # fields:'photo_50'
        name_case: 'Nom'
        v:5.29
    vk.request 'users.get', obj, (data)->
                fr = {}
                if data && data.response
                    for v in data.response
                        fr[v.id] =
                            name: "#{v.first_name} #{v.last_name}"
                            # photo: v.photo_50
                    for f, i in friends
                        friends[i]['name'] = fr[f.friend].name
                    #     friends[i]['photo'] = fr[f.friend].photo

# # #

runServer = ->
    app.set('views', './views')
    app.set('view engine', 'jade')
    app.use '/css/', express.static(__dirname + '/views/public/css/')
    app.use '/js', express.static(__dirname + '/views/public/js/')
    app.use '/maps', express.static(__dirname + '/views/public/maps/')

    app.post '/api/:action/:date1?/:date2?', (req, res)->
        result = {}
        actions =
            friends: ->
                result.content = friends

        if actions[req.params.action] then do actions[req.params.action]
        # console.log req.para
        res.json result


    app.get '/', (req, res)-> res.render 'index', {friends: []}

    server = app.listen 3000, ->
        host = server.address().address
        port = server.address().port
        clc.green("app listening at http://#{host}:#{port}")
        open("http://#{host}:#{port}")

setTimeout friendName, 400
setTimeout runServer, 1000