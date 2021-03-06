module.exports = (screen)->
    {
        FriendList: # список последних сообщений слева
            parent: screen
            alwaysScroll: false
            autoCommandKeys: true
            keys: true
            mouse: true
            selectedBold: true
            tags: true
            left: '0%'
            top: '0%'
            width: '30%'
            height: '100%'
            border:
                type: 'line'
            vi: true
            style:
                item:
                    #// bg: 'red'
                    focus:
                        bg: 'green'
                selected:
                    bg: 'blue'
        messages: # текст переписки
            parent: screen
            autoCommandKeys: true
            scrollable: true
            alwaysScroll: true
            keys: true
            mouse: true
            selectedBold: true
            tags: true
            top: '0%'
            left: '30%'
            height: '70%'
            width: '70%'
            padding: 0
            border:
                type: 'line'

            vi: true

        txt: # поле ввода текста
            border:
                type: 'line'
            inputOnFocus: true
            # // grabKeys: true
            left: '30%'
            keys: true
            # // mouse: true
            parent: screen
            style:
                fg: '#dedede'
                # // bg: 'magenta'
                border:
                    fg: '#f0f0f0'
            height: '29%'
            top: '70%'
            width: '70%'

        box: # Блок для описания состояния
            height: '6%'
            width: '50%'
            top: '96%'
            left: '30%'
            parent: screen
            tags: true
            content: "{bold}Active:{/bold} Friend list [F]"
            style:
                bg: '#22aa22'
                fg: '#222222'

        stat: # Блок для описания ошибок
            height: '6%'
            width: '70%'
            top: '98%'
            left: '30%'
            parent: screen
            tags: true
            content: "{bold}Stat:{/bold} ... "
            style:
                bg: '#223322'
                fg: '#aa8877'

        nav: # блок с описанием горячих клавиш справа
            height: '6%'
            width: '20%'
            top: '96%'
            left: '80%'
            parent: screen
            tags: true
            content: "{bold}USE:{/bold} F,T,R   {bold}Ctrl+C{/bold}"
            style:
                bg: '#aa22aa'
                fg: '#222222'

        scrollbar:
            ch: ' '
            fg: 'green'
            bg: 'green'

        listTimer: 3500 #// Через сколько обновлять сообщения
        f_count: 25 #// Количество диалогов слева
        history_count: 25
        checkOnline: 60 * 1000 #// периоды между проверками online

        do_notify: false
        message_title: 'Новое сообщение'
    }
