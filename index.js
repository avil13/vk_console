var VK = require('VK');

/**
 *   функция в которой происходит основаная работа программы
 *   вызывается полсе того как будет проверен токен
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
        Actions.messageAsReadest();
        Actions.getHistory();
        ScreenBlocks.box.setContent("{bold}Active:{/bold} Read message [R]");
        screen.render();
    });
    // ********


    /**
     * выход
     */
    ScreenBlocks.FriendList.key(['escape'], function(ch, key) {
        return process.exit(0);
    });

    /**
     * работа с полем чтрения сообщений
     */
    ScreenBlocks.messages.key(['escape'], function(ch, key) {
        ScreenBlocks.FriendList.focus();
    });

    /**
     * работа с полем ввода
     */
    ScreenBlocks.txt.key(['escape'], function(ch, key) {
        ScreenBlocks.FriendList.focus();
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


    /**
     * Обновление списков сообщений и истории
     */
    var updateLists = function() {
        //  получение списка диалогов слева
        Actions.getDialogs();
        //  получение списка истории выбранного диалога
        Actions.getHistory();
    };

    updateLists();
    setTimeout(updateLists, 1000); // для обновления имен в списке


    /**
     * Запуск обновления списков
     * проверяется количкство не прочитанных сообщений,
     * если оно изменилось, то обновляем списки
     */
    setInterval(function() {
        // Actions.unreadCount(updateLists);
        Actions.unreadCount(
            Actions.getHistory, //  получение списка истории выбранного диалога
            Actions.getDialogs //  получение списка диалогов слева
        );
    }, settings.listTimer);

    /**
     * Прверка на online друзей
     */
    setInterval(function() {
        Actions.online();
    }, settings.checkOnline);



};

// Start
VK.checkToken(openProgram);