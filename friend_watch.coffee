###
#
###

vk = require 'VK'
clc = require 'cli-color'
token =  require 'token'


###
#  объект запроса к серверу
###
reqObj =
    user_id: token.w_u || 1 # пользователь за которым следим
    list_id: 1
    online_mobile: 0
    version: 5.29

console.log(clc.blue.bgGreen.bold('   Watch for user:', reqObj.user_id, '   '))


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
# пользователь онлайн
###
online = null
###
# проверка статуса пользователя
###
isOnline = ->
    vk.request 'friends.getOnline', {version: 5.28}, (data)->
        status = (data && data.response && (data.response.indexOf(reqObj.user_id) > -1))
        if status != online
            console.log(clc.yellow('Online status:', status, '\t| ', new Date))
        online = status

###
# функция медиатор
###
ActionRequest = ->
    if online
        vk.request 'friends.getOnline', reqObj, (data)->
                 if data && data.response && data.response.length
                    console.log(clc.green(new Date,'  Ok users count:', data.response.length))
                    doRating(fr_id) for fr_id in data.response
                 else
                    console.log(clc.red('Error response\t| ', new Date))
        , (err)->
                console.log(clc.red('Error request\t| ', new Date))
                do ActionRequest



do isOnline
do ActionRequest
t = 5*60*1000 # время обновления
setInterval(ActionRequest, t)
setInterval(isOnline, 30*1000)
