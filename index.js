var VK = require('VK');

/**
 *   функция в которой происходит основаная работа программы
 *   вызывается полсе того как будет проверен товен
 */
var openProgram = function() {

    var blessed = require('blessed');
    // Create a screen object.
    var screen = blessed.screen();
    var settings = require('screen_settings')(screen);

    var ScreenBlocks = {};

    //  -------------
    ScreenBlocks.FriendList = blessed.List(settings.FriendList);

    ScreenBlocks.messages = blessed.Box(settings.messages);

    // поле ввода
    ScreenBlocks.txt = blessed.Textarea(settings.txt);

    ScreenBlocks.box = blessed.box(settings.box);

    ScreenBlocks.nav = blessed.box(settings.nav);

    screen.render();

    var Actions = require('Actions')(ScreenBlocks);


    // Quit on Escape
    screen.key(['escape'], function(ch, key) {
        return process.exit(0);
    });


    screen.key(['t', 'T', 'е', 'Е'], function(ch, key) {
        ScreenBlocks.txt.focus();
    });

    screen.key(['f', 'F', 'а', 'А'], function(ch, key) {
        ScreenBlocks.FriendList.focus();
    });

    screen.key(['r', 'R', 'к', 'К'], function(ch, key) {
        ScreenBlocks.messages.focus();
    });


    // ******** focuses ********
    ScreenBlocks.FriendList.on('focus', function() {
        ScreenBlocks.box.setContent("{bold}Active:{/bold} Friend list [F]");
        screen.render();
    });

    ScreenBlocks.txt.on('focus', function() {
        ScreenBlocks.box.setContent("{bold}Active:{/bold} Text write [T]");
        screen.render();
    });

    ScreenBlocks.messages.on('focus', function() {
        ScreenBlocks.box.setContent("{bold}Active:{/bold} Read message [R]");
        screen.render();
    });
    // ********


    /**
     * работа с полем ввода
     */
    ScreenBlocks.txt.key(['escape'], function(ch, key) {
        ScreenBlocks.FriendList.focus();
        ScreenBlocks.box.setContent("{bold}Active:{/bold} Friend list [F]");
        screen.render();
    });



    /**
     * отправка сообщения
     */
    ScreenBlocks.txt.key(['C-c'], function() {
        var textMsg = ScreenBlocks.txt.getValue();

        Actions.send(textMsg);

        // messages.add("{bold}{blue-bg}I'm:{/blue-bg}{/bold} " + t);
        // messages.setScrollPerc(100);
        // screen.render();
    });



    /**
     * Выбор диалога для беседы
     */
    ScreenBlocks.FriendList.on('select', function(index) {
        // получение id mid текущей беседы, и запись этого значения в переменную
        var id = Actions.getID(index.content);

        // отправляем запрос на соединение и получение последних сообщений
        if (id) {
            Actions.getHistory(id);
        }
    });



    // ===================================
    //  получение списка диалогов
    Actions.getDialogs(settings.f_count);
    //  обновление списка диалогов
    setInterval(function() {
        Actions.getDialogs(settings.f_count);
    }, settings.freienListTimer);


    // ====================================
    // Обновление сообщений
    setInterval(Actions.getHistory, settings.messageTimer);

};

// Start
VK.checkToken(openProgram);