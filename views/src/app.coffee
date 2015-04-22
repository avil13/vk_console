APP = angular.module 'APP', ['chart.js']


###
# Яндекс карта
###
APP.directive 'yaMap', [
    ->
        restrict: 'E'
        templateUrl: 'template/directives/ya-map.html'
        scope:
            coordinate: '='

        link: (scope, element, attrs)->

            YaMap = element.children().children()[1].children[0]
            cross = element.children().children()[1].children[1]

            scope.equalCoord = ()->
                scope.coordinate = scope.center

            # // отображение координат в поле
            showCoord = (myMap)->
                cen = myMap.getCenter()
                scope.center = cen.join(', ')
                scope.$apply()

            # // установка перекрестия по середине
            setCross = (myMap, cross)->
                size = myMap.container.getSize()
                cross.style.left = size[0] / 2 - 14 + 'px'
                cross.style.top = size[1] / 2 + 22 + 'px'
                showCoord(myMap)

            ymaps.ready ()->
                # // если есть уже координаты то выставим их
                coord = scope.coordinate.split(',') if scope.coordinate
                center = [55.72504493, 37.64696100]

                if coord? && coord.length == 2
                    coord[0] = parseFloat(coord[0])
                    coord[1] = parseFloat(coord[1])
                    center = coord

                # // создание карты
                myMap = new ymaps.Map YaMap,
                    center: center
                    zoom: 18

                setCross myMap, cross

                myMap.events.add ['resultselect', 'boundschange'], (e)->
                    setCross myMap, cross

]

