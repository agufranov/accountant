angular.module 'app.controllers'

  .controller 'addCtrl', [
    '$scope'
    '$state'
    'Db'
    ($scope, $state, Db) ->
      Db.prepared ->
        Db.snapshot ['wallets', 'types']
          .then (snapshot) ->
            _.extend $scope, snapshot
            $scope.source_id = (_.find($scope.wallets, type: 'cash') or _.first($scope.wallets)).id

      $scope.submit = ->
        Db.ready ->
          o = {
            source_id: $scope.source_id
            type_id: $scope.type_id
            sum: Math.floor($scope.sum * 100)
          }
          Db.flows.insert o
        .then(
          ->
            $state.go 'app.main'
          ->
            alert 'Заполните все поля'
        )
  ]
