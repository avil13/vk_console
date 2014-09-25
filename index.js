var VK = require('VK');

/**
*   функция в которой происходит основаная работа программы
*   вызывается полсе того как будет проверен товен
*/
var openProgram = function() {

    var blessed = require('blessed');
    // Create a screen object.
    var screen = blessed.screen();
    var blocks = require('screen_blocks')(screen);

    //  -------------
    var FriendList = blessed.List(blocks.FriendList);
    // screen.append(FriendList);

    var msg = blessed.Box(blocks.msg);

    // поле ввода
    var txt = blessed.Textarea(blocks.txt);

    var box = blessed.box(blocks.box);

    var nav = blessed.box(blocks.nav);


    screen.render();

    var Actions = require('Actions')(screen);


    // Quit on Escape, q, or Control-C.
    screen.key(['escape', 'C-c'], function(ch, key) {
        return process.exit(0);
    });


    screen.key(['t', 'T', 'е', 'Е'], function(ch, key) {
        box.setContent("{bold}Active:{/bold} Text write [T]");
        Actions.can_read = true;
        txt.focus();
        screen.render();
    });

    screen.key(['f', 'F', 'а', 'А'], function(ch, key) {
        box.setContent("{bold}Active:{/bold} Friend list [F]");
        FriendList.focus();
        screen.render();
    });

    screen.key(['r', 'R', 'к', 'К'], function(ch, key) {
        box.setContent("{bold}Active:{/bold} Read message [R]");
        msg.focus();
        screen.render();
    });



    // работа с полем ввода
    txt.key(['escape'], function(ch, key) {
        box.setContent("{bold}Active:{/bold} Friend list [F]");
        screen.render();
    });

    // ==========================
    // отправка сообщения
    txt.key(['C-c'], function() {
        var t = txt.getValue();

        txt.clearValue();

        // Actions.send(t, message_id, msg, screen);

        // msg.add("{bold}{blue-bg}I'm:{/blue-bg}{/bold} " + t);
        // msg.setScrollPerc(100);
        // screen.render();
    });

    // ===========================
    // получение списка диалогов
    setTimeout(Actions.getDialogs, 5000);

    // ===========================
    // Выбор диалога для беседы
    // ===========================
    //




};

// Start
VK.checkToken(openProgram);

