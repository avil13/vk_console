open = require('open')
vk = require 'VK'
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
    vk.request 'users.get', {user_ids: ids.join(','), fields:'verifieds', name_case:'Nom', v:5.8}, (data)->
                fr = {}
                if data && data.response
                    for v in data.response then fr[v.id] = "#{v.first_name} #{v.last_name}"
                    for f, i in friends then friends[i]['name'] = fr[f.friend]
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

setTimeout friendName, 1000
setTimeout action, 3000