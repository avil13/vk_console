var https = require('https'),
    fs = require('fs'),
    token = false,
    // user_id = '19230273';
    user_id = false;

var VK = {

    // Проверка токена на действительность
    _httpCheckToken: function() {

        var self = this;
        var options = {
            host: 'api.vk.com',
            port: 443,
            path: '/method/users.get?access_token=' + token
        };

        var req = https.get(options, function(res) {
            res.setEncoding('utf8');

            res.on('data', function(ans) {
                ans = JSON.parse(ans);

                if (!(ans && ans.response)) {
                    token = false;
                    user_id = false;

                    fs.writeFile(__dirname + '/token.json', '{}', function(err){
                        console.log( err );
                    });

                    self.checkToken();
                }
            });

        }).on('error', function(err) {
            console.log( err );
        });

        req.end();
    },

    //    ==========
    // проверка наличия записи о токене и занесение его в память
    checkToken: function() {
        var self = this;

        var readline = require('readline');

        var rl = readline.createInterface({
            input: process.stdin,
            output: process.stdout
        });

        var fileJSON;

        try {

            fileJSON = require(__dirname + '/token.json');

        } catch (err) {

            fileJSON = false;

        }

        if (fileJSON && fileJSON.token && fileJSON.user_id) {

            token = fileJSON.token;
            user_id = fileJSON.user_id;
            self._httpCheckToken();

        } else {

            var msg = "Вам нужно получить новый токен, пройдите по адресу\n" +
                "результат получившийся в адресной строке занесите сюда\n\n" +
            // " http://vk.cc/2XggaK \n\n\n";
            "\033[32m http://vk.cc/2XggaK \033[0m \n\n\n";
            // "https://oauth.vk.com/authorize?client_id=3270660&scope=notify,friends,status,messages,offline&redirect_uri=https://oauth.vk.com/blank.html&display=page&v=5.21&response_type=token\n\n";

            rl.question(msg, function(answer) {
                // запись токена
                if (answer && answer.split('access_token=')[1]) {
                    answer = answer.split('access_token=')[1];
                    token = answer.split('&')[0];
                    user_id = answer.split('user_id=')[1].split('&')[0];
                }

                if (!token) {
                    throw ("\n\nПолучен не верный токен\n\n");
                }

                var tkn = JSON.stringify({
                    token: token,
                    user_id: user_id
                }, null, 4);


                fs.writeFile(__dirname + '/token.json', tkn, function(err) {
                    if (err) return console.log(err);
                });

                rl.close();

                self._httpCheckToken();
            });

        }

    },

    //  ========
    // отправка запроса
    request: function(_method, _params, _callback){

        if (!user_id) {
            // Если не активирован, просим пересоздать токен
            this.checkToken();
            return false;
        }

        var options = {
            method: 'GET',
            host: 'api.vk.com',
            port: 443,
            path: '/method/' + _method + '?access_token=' + token
        };


        for (var key in _params) {
            if (key === "message") {
                options.path += ('&' + key + '=' + encodeURIComponent(_params[key]));
            } else {
                options.path += ('&' + key + '=' + _params[key]);
            }
        }

        var req = https.request(options, function(res) {
            res.setEncoding('utf8');

            res.on('data', function(ans) {

                // debugger;

                ans = JSON.parse(ans);

                if (_callback) {
                    _callback(ans);
                }
            });

        }).on('error', function(err) {
            if (_callback) {
                _callback(err);
            }
        });

        req.end();
    }

};

VK.checkToken();

// setTimeout(function() {

    VK.request('messages.getHistory', {
        count: 2,
        v: 5.21,
        user_id: user_id
    }, function(data){
        console.log( 'return: ',data );
    });

// }, 3000);

// module.exports = VK;