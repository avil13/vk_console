###
#
###

vk = require 'VK'
clc = require 'cli-color'
myID =  require 'token'


sqlite3 = require('sqlite3').verbose()
db = new sqlite3.Database('mydb.db')
db.run("CREATE TABLE if not exists user_friend (user INT, friend INT, rating INT)")


###
#  строка в число
###
int = (str)-> parseInt( (str +='').replace(/\D+/g,""), 10)

###
#  создаем запись
###
insRating  = (friend_id, rating)->
    db.run("INSERT INTO user_friend VALUES (?, ?, ?)", [reqObj.user_id, friend_id, rating])

###
#  обновляем запись
###
upRating  = (friend_id, rating)->
    db.run("UPDATE user_friend SET rating=$rating WHERE friend=$friend AND user=$user", {
        $user: reqObj.user_id
        $friend: friend_id
        $rating: rating
    })

###
# увеличиваем рейтинг
###
doRating = (fr_id)->
    db.get "SELECT rating FROM user_friend WHERE user=#{reqObj.user_id} AND friend=#{fr_id}", (err, row)->
        if row == undefined
            insRating(fr_id, 1)
        else
            upRating(fr_id, int(row.rating)+1)


###
#  объект запроса к серверу
###
reqObj =
    user_id: 1
    list_id: 1
    online_mobile: 0
    version: 5.29

ActionRequest = ->
    vk.request 'friends.getOnline', reqObj, (data)->
             if data && data.response && data.response.length
                 console.log(clc.green(new Date,'  Ok users count:', data.response.length))
                 doRating(fr_id) for fr_id in data.response
             else
                console.log(clc.red(new Date,'  Error response'))
    , (err)->
            console.log(clc.red(new Date,'  Error request'))
            do ActionRequest



do ActionRequest
t = 5*60*1000 # время обновления
setInterval(ActionRequest, t)
