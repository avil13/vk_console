open = require('open')
vk = require 'VK'
token = require('token')
express = require('express')
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

action = ->
    app.set('views', './views')
    app.set('view engine', 'jade')

    app.get '/', (req, res)->
        # res.send('hello world')
        res.render 'index', {friends: friends}


    server = app.listen 3000, ->
        host = server.address().address
        port = server.address().port
        console.log('app listening at http://%s:%s', host, port)
        open("http:/#{host}:#{port}")

setTimeout friendName, 500
setTimeout action, 2000