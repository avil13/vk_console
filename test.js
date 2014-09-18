var scrn = {
    txt: 1111
};

var Actions = require('Actions')(scrn);


////


/*

FriendList.on('select', function(index) {
    // получение id mid текущей беседы, и запись этого значения в переменную
    var id = Actions.getID(index.content);
    message_id = id;

    // отправляем запрос на соединение и получение последних сообщений
    if (id) {
        Actions.getHistory(id, msg, screen);
    }
});
*/

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


//////

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

// *    ****************
// screen.append(txt);

