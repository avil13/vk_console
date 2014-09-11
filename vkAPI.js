var https = require('https'),
    fs = require('fs'),
    token = false;

VK = {

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

                if(!(ans && ans.response)){
                    token = false;

                    fs.unlink(__dirname + '/../token.json', function(err) {
                        if (err) return console.log(err);
                    });

                    self.checkToken();
                }
            });

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
            fileJSON = require(__dirname + '/../token.json');
        } catch (err) {
            fileJSON = false;
        }

        if (fileJSON && fileJSON.token) {

            token = fileJSON.token;

            self._httpCheckToken();

        } else {

            var msg = "Вам нужно получить новый токен, пройдите по адресу\n" +
                "результат получившийся в адресной строке занесите сюда\n\n" +
                "http://vk.cc/2XggaK\n\n\n";
            // "https://oauth.vk.com/authorize?client_id=3270660&scope=notify,friends,status,messages,offline&redirect_uri=https://oauth.vk.com/blank.html&display=page&v=5.21&response_type=token\n\n";

            rl.question(msg, function(answer) {
                // запись токена
                if (answer && answer.split('=')[1]) {
                    token = answer.split('=')[1].split('&')[0];
                }
                if (!token) {
                    throw ("\n\nПолучен не верный токен\n\n");
                }

                var tkn = JSON.stringify({
                    token: token
                }, null, 4);


                fs.writeFile(__dirname + '/../token.json', tkn, function(err) {
                    if (err) return console.log(err);
                });

                rl.close();

                self._httpCheckToken();
            });

        }
    }

};

VK.checkToken();

// module.exports = VK;