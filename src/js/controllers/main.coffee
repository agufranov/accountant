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
        Db.snapshot ['wallets', 'types']
      .then (snapshot) ->
        _.extend $scope, snapshot
      .then ->
        # where:
        #   date:
        #     gt: moment().subtract(3, 'hours').unix()
        Db.flows.select()
      .then (flows) ->
        $scope.flows = flows.map f
      .then ->
        Db.updateWallets()
      .then (res) ->
        Db.wallets.select()
      .then (wallets) -> $scope.wallets = wallets
  ]
