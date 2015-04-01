APP = angular.module 'APP', ['chart.js']

APP.controller 'MainCtrl', ['$scope', '$http', ($scope, $http)->
    post = (url, data, callback)->
        if !callback && data instanceof Function
            callback = data
            data = {}
        $http.post(url, data)
            .success (data)->
                callback data if callback
            .error (console.log)
        return

    #
    post '/api/friends/', (data)->
        $scope.friends = data.content if data.content

    #
    return
]