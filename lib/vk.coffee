https = require('https')
open = require('open')
fs = require('fs')
token = false
user_id = false

# color
green = '\033[0;32m'
red = '\033[0;31m'
end = '\033[0m'
log = (msg, error=false)-> console.log (error ? red : green) + "\n" + msg + "\n" + end

VK =
# Проверка токена на действительность
_httpCheckToken: (_callback)->
    self = this
    options =
        host: 'api.vk.com'
        port: 443
        path: '/method/users.get?access_token=' + token

    req = https.get options, (res)->
        str = ''
        req = http.get url, (res)->
            res.setEncoding('utf8')
            res.on 'data', (chunk)->
                str += chunk
            res.on 'end', ->
                try str = JSON.parse(str)
                catch e then return log e, 1
                fs.writeFile "#{__dirname}/token.json", '{}', (err)-> log err, 1
                _callback(obj)
                if !(str && str.response)
                    token = user_id = false
                    fs.writeFile "#{__dirname}/token.json", '{}', (err)->
                        log err, 1 if err
                        log "Ошибка при проверке токена\nпопробуйте еще раз", 1
                        process.exit()
            res.on 'error', (err)->
                log "Ошибка при запросе проверки токена", 1
                log err, 1
    req.end()


# // проверка наличия записи о токене и занесение его в память
checkToken: (_callback)->
    self = this
    readline = require('readline')
    try
        fileJSON = require(__dirname + '/token.json')
    catch e
        fileJSON = false


    if fileJSON && fileJSON.token && fileJSON.user_id
        token = fileJSON.token
        user_id = fileJSON.user_id
        self._httpCheckToken(_callback)
    else
        rl = readline.createInterface {
                    input: process.stdin,
                    output: process.stdout
                }

        msg = "Вам нужно получить новый токен, пройдите по адресу\n" +
            " http://vk.cc/3DsQU0\n"+
            "результат получившийся в адресной строке занесите сюда\n" +
            "и перезапустите программу\n\n";
        # // "https://oauth.vk.com/authorize?client_id=3270660&scope=notify,friends,status,messages,offline,photos,audio&redirect_uri=https://oauth.vk.com/blank.html&display=page&v=5.21&response_type=token\n\n";
        setTimeout ( -> open('http://vk.cc/3DsQU0') ), 1000

        rl.question msg, (answer)->
            # // запись токена
            if answer && answer.split('access_token=')[1]
                answer = answer.split('access_token=')[1]
                token = answer.split('&')[0]
                user_id = answer.split('user_id=')[1].split('&')[0]

            if !token then throw log 'Получен не верный токен', 1

            tkn = JSON.stringify({
                token: token
                user_id: user_id
                w_u: 1
            }, null, 4)

            fs.writeFile "#{__dirname}/token.json", tkn, (err)-> if err then log(err, 1)
            rl.close()
            self._httpCheckToken()


# // отправка запроса
request: (_method, _params, _callback, _err)->
    # // Если не активирован, просим пересоздать токен
    if !user_id then this.checkToken()

    options = {
        method: 'GET'
        host: 'api.vk.com'
        port: 443
        path: "/method/#{_method}?access_token=#{token}"
    }

    for own key, val of _params
        options.path += "&#{key}=#{if key == "message" then encodeURIComponent(val) else val}"

    req = https.request options, (res)->
        str = ''
        res.setEncoding('utf8')
        res.on 'data', (chunk)-> str += chunk

        res.on 'end', (err)->
            if err then return log(err, 1)
            try
                ans = JSON.parse(ans);
                if _callback then _callback(ans)
            catch e
                log(e, 1)
                return false
        res.on 'error', (err)->
            if _err then _err err
    req.end()







