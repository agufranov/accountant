angular.module 'app'

  .directive 'num', [
    ->
      scope:
        value: '=ngModel'
      templateUrl: 'directives/num/num.html'
      controller: [
        '$scope'
        ($scope) ->
          $scope.rows = [
            [ 1 , 2 , 3 ]
            [ 4 , 5 , 6 ]
            ['.', 0, '<']
          ]
          $scope.point = false
          $scope.value = $scope.value.toString()
          $scope.press = (val) ->
            switch val
              when '<' then backspace()
              when '.' then point()
              else addNum(val)

          backspace = ->
            $scope.point = false if $scope.value[-1..] is '.'
            $scope.value = $scope.value[...$scope.value.length - 1]

          point = ->
            unless $scope.point
              $scope.point = true
              $scope.value += '.'

          addNum = (num) ->
            $scope.value += num
            $scope.value = $scope.value.replace /^0+/, ''
      ]
  ]
