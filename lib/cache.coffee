
cache =
    storage:
        message: ''
        history: ''
        unreadest: ''

    check: (type, data)->
        d = JSON.stringify(data) if typeof data == 'object'
        t = if type == 'm' || type == 'message' then 'message'
        t = if type == 'h' || type == 'history' then 'history'
        t = if type == 'u' || type == 'unreadest' then 'unreadest'
        res = @storage[t] == d
        @storage[t] = d if !res
        !res

    clear: (type = false)->
        if type == false
            @storage['message'] = ''
            @storage['history'] = ''
            @storage['unreadest'] = ''
        else
            t = if type == 'm' || type == 'message' then 'message'
            t = if type == 'h' || type == 'history' then 'history'
            t = if type == 'u' || type == 'unreadest' then 'unreadest'
            @storage[t] = ''



# ===
module.exports = cache