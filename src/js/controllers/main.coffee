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

      if ionic.Platform.isWebView()
        Db.prepared ->
          Db.updateWallets()
        .then ->
          Db.flows.select()
        .then (flows) ->
          $scope.flows = flows.map f
      else
        $scope.flows = [
          {
            sum: 50000
            type_id: 1
            date: Date.now()
            source_id: 1
          }
        ]
  ]
