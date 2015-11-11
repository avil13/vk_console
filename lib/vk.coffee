https    = require 'https'
open     = require 'open'
fs       = require 'fs'
clc      = require 'cli-color'
readline = require 'readline'
h        = require './helper.coffee'
token    = false
user_id      = false

# color
log = (msg, error=false)-> console.log (if error then  clc.red("\n#{msg}\n") else clc.green("\n#{msg}\n"))

VK =
# // проверка наличия записи о токене и занесение его в память
checkToken: (callback, err)->
    try
        fileJSON = require('./token.json')
    catch e
        fileJSON = false

    if fileJSON && fileJSON.token && fileJSON.user_id
        token = fileJSON.token
        user_id = fileJSON.user_id

        @request 'users.get', {}, callback, (err)->
            log "Ошибка при запросе проверки токена", 1
            fs.writeFileSync "#{__dirname}/token.json", '{}', 'utf8', (err)-> if err then log(err, 1)
            process.exit()

    else
        rl = readline.createInterface {
                    input: process.stdin,
                    output: process.stdout
                }
        msg = """
            Вам нужно получить новый токен, пройдите по адресу
             http://vk.cc/3DsQU0
            результат получившийся в адресной строке занесите сюда
            и перезапустите программу
            >>
            """;
        setTimeout ( -> open('http://vk.cc/3DsQU0') ), 1000
        rl.question msg, (answer)->
            # // запись токена
            token = h.url_param(answer, 'access_token')
            user_id = h.url_param(answer, 'user_id')

            if !token then throw log 'Получен не верный токен', 1

            tkn = JSON.stringify({token: token, user_id: user_id}, null, 4)

            fs.writeFileSync "#{__dirname}/token.json", tkn, 'utf8', (err)-> if err then log(err, 1)
            rl.close()
            process.exit()



# // отправка запроса
request: (_method, _params, _callback, _err)->
    # // Если не активирован, просим пересоздать токен
    if !user_id then @checkToken()

    options =
        method: 'GET'
        host: 'api.vk.com'
        port: 443
        path: "/method/#{_method}?access_token=#{token}"
    _path = []

    for own key, val of _params
        _path.push "#{key}=#{if key == "message" then encodeURIComponent(val) else val}"
    if !_params['v'] then _path.push "v=5.37"
    options.path += _path.join('&')

    console.log("\n\n#{options.path}\n\n") #===

    req = https.request options, (res)->
        str = ''
        res.setEncoding('utf8')
        res.on 'data', (chunk)-> str += chunk
        res.on 'end', (err)->
            if err then return log(err, 1)
            try
                ans = JSON.parse(str)
                console.log ans #===
                if ans.response
                    _callback? ans.response, ans, str
                else
                    _err ans
            catch e
                log(e, 1)
        res.on 'error', (err)->
            if _err then _err err
    req.end()



# # # # #
module.exports = VK

