h = require './../lib/helper.coffee'
jasmine = require 'jasmine-node'

describe 'helper-test', ->

    it 'url_param', ->
        url = 'https://oauth.vk.com/blank.html#access_token=my-token&expires_in=0&user_id=19230273'
        access_token = h.url_param(url, 'access_token')
        user_id = h.url_param url, 'user_id'
        expect(access_token).toEqual('my-token')
        expect(user_id).toEqual('19230273')


    it 'arg', ->
        all = h.arg()
        expect(all).toEqual(jasmine.any(Array))

    it 't', ->
        expect(h.t(1)).toEqual('01')
        expect(h.t(11)).toEqual('11')

    it 'date', ->
        expect(h.date(1447408397)).toEqual('12:53 13.11.2015')

    it 'int', ->
        expect(h.int('hello 101 man')).toEqual 101

    it 'getID', ->
        user = h.getID 'Иванов Иван __u_101010__'
        expect(user).toEqual(jasmine.any(Object))
        expect(user.id).toEqual(101010)
        expect(user.is_chat).toEqual(false)

        chat = h.getID 'Тестовый чат __ch_123456__'
        expect(chat).toEqual(jasmine.any(Object))
        expect(chat.id).toEqual(123456)
        expect(chat.is_chat).toEqual(true)