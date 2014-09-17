var blessed = require('blessed');

// Create a screen object.
var screen = blessed.screen();
var blocks = require('screen_blocks')(screen);

/****************************
 __________  ____  __  ___
 / ____/ __ \/ __ \/  |/  /
 / /_  / / / / /_/ / /|_/ /
 / __/ / /_/ / _, _/ /  / /
 /_/    \____/_/ |_/_/  /_/

 */


var FriendList = blessed.List(blocks.FriendList);
//screen.append(FriendList);



var msg = blessed.Box(blocks.msg);

// поле ввода
var txt = blessed.Textarea(blocks.txt);
screen.append(txt);


var box = blessed.box(blocks.box);

var nav = blessed.box(blocks.nav);


// screen.render();

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

// send message
txt.key(['C-c'], function() {
    var t = txt.getValue();

    txt.clearValue();

    Actions.send(t, message_id, msg, screen);

    // msg.add("{bold}{blue-bg}I'm:{/blue-bg}{/bold} " + t);
    // msg.setScrollPerc(100);
    // screen.render();
});

/*
screen.key('tab', function(ch, key) {
    if (!key.shift) {
        screen.focusNext();
    } else {
        screen.focusPrev();
    }
    screen.render();
});
*/

/****
 -----------
 */
// переменная для хранения ID беседы
var message_id = 0;


FriendList.on('select', function(index) {
    // получение id mid текущей беседы, и запись этого значения в переменную
    var id = Actions.getID(index.content);
    message_id = id;

    // отправляем запрос на соединение и получение последних сообщений
    if (id) {
        Actions.getHistory(id, msg, screen);
    }
});


// setInterval(function() {

//     Actions.getDialogs(FriendList, screen, msg);

    //    память
       // var m = process.memoryUsage().heapUsed;
       // box.setContent( m+''  );
       // nav.setContent( (Math.random() * (99 - 1) + 1)+'');
// }, 3000);

// setInterval(function() {
//     Actions.friends();
//     // if (message_id)
//         // Actions.getHistory(message_id, msg, screen);
// }, 2660);

