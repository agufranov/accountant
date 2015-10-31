angular.module 'app.controllers'

  .controller 'mainCtrl', [
    '$scope'
    'Db'
    ($scope, Db) ->
      f = (flow) ->
        flow.date = flow.date * 1000
        flow.type = _.find Db.cache.types, id: flow.type_id
        flow.wallet = _.find Db.cache.wallets, id: flow.source_id
        flow

      $scope.filter = {}

      Db.prepared ->
        Db.updateWallets()
      .then ->
        Db.flows.select()
      .then (flows) ->
        $scope.flows = flows.map f
      #
      # $scope.addWallet = ->
      #   Db.transaction (tx) ->
      #     Db.flows.insert { sum: 500, type_id: 0 }, {}, tx
      #     Db.wallets.insert { name: 'test', type: 'card', balance: 0 }, {}, tx
  ]
