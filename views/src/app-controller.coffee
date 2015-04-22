
APP.controller 'MainCtrl', ['$scope', '$http', '$window', ($scope, $http, $window)->
    Post = (url, data, callback, err)->
        if !callback && data instanceof Function
            callback = data
            data = {}
        $http.post(url, data)
            .success (data)->
                callback data if callback
            .error (data, status)->
                if err instanceof Function then err(data, status)
    #
    Post '/api/friends/', (data)->
        $scope.friends = data.content if data.content
    #
    isRun = ->
        Post '/api/is_runing', {}
        , (data)->
            if data.status != true then do $window.close
        , (data, status)->
            # if data == null && !status then do $window.close
    #
    setInterval isRun, 5000
    #


    # координаты карты
    $scope.coordinate = '55.72504493,37.64696100'


    # ####
    return
]