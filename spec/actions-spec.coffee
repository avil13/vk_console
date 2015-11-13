actions = require './../lib/actions.coffee'
jasmine = require 'jasmine-node'

describe 'actions-test', ->
    it 'setCong getConf', ->
        actions.setConf 100
        conf = actions.getConf()
        expect(conf).toEqual(jasmine.any(Object))
        expect(conf.message_id).toEqual(100)

    it 'getDialogs', ->
        actions.getDialogs (res)->
            expect(res).toEqual(jasmine.any(Object))
            expect(res.items).toEqual(jasmine.any(Array))
            done()

    # it 'getHistory', ->
    #     actions.getHistory 1, on, (res)->
    #         expect(res).toEqual(jasmine.any(Object))
    #         expect(res.items).toEqual(jasmine.any(Array))
    #         done()

