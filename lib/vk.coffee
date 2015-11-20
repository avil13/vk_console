h        = require('./helper')
https    = require 'https'
open     = require 'open'
fs       = require 'fs'
readline = require 'readline'
clc      = require 'cli-color'
token    = false
user_id  = false



# переменная для подсчета количества запросов
count_of_requests = 0

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
                    #{clc.green('http://vk.cc/3DsQU0')}
                результат получившийся в адресной строке занесите сюда
                и перезапустите программу
                #{clc.green('>> ')}
                """
            unless h.arg('debug') then setTimeout (-> open('http://vk.cc/3DsQU0')), 1000
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
            path: ["/method/#{_method}?access_token=#{token}"]

        for own key, val of _params
            options.path.push "#{key}=#{if key == "message" then encodeURIComponent(val) else val}"
        if !_params['v'] then options.path.push "v=5.40"
        options.path = options.path.join('&')

        if h.arg('url') then console.log("\nhttps://#{options.host}/#{options.path}\n") #debug
        if h.arg('req_stat') #debug
            ++count_of_requests
            h.errorStat "[#{count_of_requests}] https://#{options.host}/#{options.path}"

        try
            req = https.request options, (res)->
                str = ''
                res.setEncoding('utf8')
                res.on 'data', (chunk)-> str += chunk
                res.on 'end', (err)->
                    if err then return log(err, 1)
                    try
                        ans = JSON.parse(str)
                        if h.arg('debug') then console.log(ans) #debug

                        if ans.response
                            _callback? ans.response, ans, str
                        else
                            _err ans
                    catch e
                        log(e, 1)
                res.on 'error', (err)->
                    if h.arg('debug') then log(ans, 1) #debug
                    if _err then _err err
            req.end()
        catch e
            if _err then _err e


    # Ответ промисом
    pr: (_method, _params)->
        self = @
        new Promise (resolve, reject)->
            self.request(_method, _params, resolve, reject)


VK.r = VK.req = VK.request

module.exports = VK