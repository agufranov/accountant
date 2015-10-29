angular.module 'app.controllers'

  .controller 'addCtrl', [
    '$scope'
    'Db'
    ($scope, Db) ->
      Db.prepared ->
        Db.snapshot ['wallets', 'types']
          .then (snapshot) ->
            _.extend $scope, snapshot
            $scope.source_id = (_.find($scope.wallets, type: 'cash') or _.first($scope.wallets)).id
  ]
