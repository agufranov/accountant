angular.module 'app.controllers'

  .controller 'addCtrl', [
    '$scope'
    '$state'
    '$cordovaToast'
    'Db'
    ($scope, $state, $cordovaToast, Db) ->
      Db.prepared ->
        $scope.source_id = (_.find(Db.cache.wallets, type: 'cash') or _.first(Db.cache.wallets)).id

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
            $cordovaToast.showShortCenter 'Заполните все поля'
        )
  ]
