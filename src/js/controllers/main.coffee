angular.module 'app.controllers'

  .controller 'mainCtrl', [
    '$scope'
    'Db'
    ($scope, Db) ->
      f = (flow) ->
        flow.date = flow.date * 1000
        flow.type = _.find $scope.types, id: flow.type_id
        flow.wallet = _.find $scope.wallets, id: flow.source_id
        flow

      $scope.filter = {}

      Db.prepared ->
        Db.updateWallets()
      .then ->
        Db.snapshot ['wallets', 'types']
      .then (snapshot) ->
        _.extend $scope, snapshot
      .then ->
        Db.flows.select()
      .then (flows) ->
        $scope.flows = flows.map f
  ]
