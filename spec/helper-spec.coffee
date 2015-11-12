h = require './../lib/helper.coffee'

describe 'helper-test', ->

    it 'arg', ->
        all = h.arg()
        expect(Array.isArray(all)).toBeTruthy()