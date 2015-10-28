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

      Db.prepared ->
        Db.wallets.select()
      .then (wallets) -> $scope.wallets = wallets

      .then -> Db.types.select()
      .then (types) -> $scope.types = types

      .then ->
        # where:
        #   date:
        #     gt: moment().subtract(3, 'hours').unix()
        Db.flows.select()
      .then (flows) ->
        $scope.flows = flows.map f
  ]
