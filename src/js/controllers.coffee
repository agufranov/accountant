angular.module 'app.controllers', ['angularMoment']
  .controller 'mainCtrl', [
    '$scope'
    'Db'
    ($scope, Db) ->
      f = (flow) ->
        flow.date = flow.date * 1000
        flow.sum = (flow.sum / 100).toFixed 2
        flow.type = _.find $scope.types, id: flow.type_id
        flow.wallet = _.find $scope.wallets, id: flow.source_id
        flow

      Db.connect()
        .then -> Db.wallets.select()
        .then (wallets) -> $scope.wallets = wallets

        .then -> Db.types.select()
        .then (types) -> $scope.types = types

        .then ->
          Db.flows.select
            where:
              date:
                gt: moment().subtract(3, 'hours').unix()
        .then (flows) ->
          $scope.flows = flows.map f
  ]

  .controller 'addCtrl', [
    '$scope'
    ($scope) ->
  ]
