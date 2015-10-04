// ┌─┐
// └─┘

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


function rand(Arr) {
    var min = 0;
    var max = Arr.length - 1;

    return Arr[Math.floor(Math.random() * (max - min + 1)) + min];
}

Names = ['Джон', 'Стив', 'Билл', 'Денис', 'Анна', 'Елена', 'Галина'];
SurNames = ['Сильвер', 'Джобс', 'Гейтс', 'Балмер', 'Родман', 'Джексон', 'Веллер'];

/// ====

for (var i = 0; i < 30; i++) {
    ScreenBlocks.FriendList.add('{bold}' + rand(Names) + ' ' + rand(SurNames) + ' {/bold} » text of your mesage');
}
screen.render();