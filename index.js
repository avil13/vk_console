var blessed = require('blessed');

// Create a screen object.
var screen = blessed.screen();

var Actions = require('Actions')(screen);


var border = {
    type: 'line'
};

var style = {
    fg: '#dedede',
    // bg: 'magenta',
    border: {
        fg: '#f0f0f0'
    }
};

var scrollbar = {
    ch: ' ',
    fg: 'green',
    bg: 'green',
};

/****************************
 __________  ____  __  ___
 / ____/ __ \/ __ \/  |/  /
 / /_  / / / / /_/ / /|_/ /
 / __/ / /_/ / _, _/ /  / /
 /_/    \____/_/ |_/_/  /_/

 */


var FriendList = blessed.List({
    alwaysScroll: false,
    autoCommandKeys: true,
    height: '100%',
    keys: true,
    left: '0%',
    mouse: true,
    parent: screen,
    selectedBold: true,
    tags: true,
    top: '0%',
    width: '30%',
    border: {
        type: 'line'
    },
    vi: true,
    style: {
        item: {
            // bg: 'red',
            focus: {
                bg: 'green'
            }
        },
        selected: {
            bg: 'blue'
        }

    }
});
//screen.append(FriendList);



var msg = blessed.Box({
    autoCommandKeys: true,
    scrollable: true,
    alwaysScroll: true,
    height: '70%',
    keys: true,
    left: '30%',
    mouse: true,
    parent: screen,
    selectedBold: true,
    tags: true,
    top: '0%',
    width: '70%',
    border: {
        type: 'line'
    },
    vi: true
});

// поле ввода
var txt = blessed.Textarea({
    border: border,
    height: '28%',
    inputOnFocus: true,
    left: '30%',
    keys: true,
    parent: screen,
    style: style,
    top: '70%',
    width: '70%'
});
screen.append(txt);


var box = blessed.box({
    height: '6%',
    width: '50%',
    top: '96%',
    left: '30%',
    parent: screen,
    tags: true,
    content: "{bold}Active:{/bold} Friend list [F]",
    style: {
        bg: '#22aa22',
        fg: '#222222'
    }
});

var nav = blessed.box({
    height: '6%',
    width: '20%',
    top: '96%',
    left: '80%',
    parent: screen,
    tags: true,
    content: "{bold}USE:{/bold} F, T, R",
    style: {
        bg: '#aa22aa',
        fg: '#222222'
    }
});

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

setInterval(function() {
    Actions.friends();
    // if (message_id)
        // Actions.getHistory(message_id, msg, screen);
}, 2660);



// screen.render();