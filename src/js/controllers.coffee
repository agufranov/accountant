angular.module 'app.controllers', []

  .controller 'addCtrl', [
    '$scope'
    '$q'
    'Db'
    ($scope, $q, Db) ->
      $scope.wallets = [
        { id: 1, name: 'Карта', icon: 'ion-card', balance: '36 000' }
        { id: 2, name: 'Кошелек', icon: 'ion-cash', balance: '5 000' }
      ]

      Db.connect()
        .then ->
          Db.resetTables()
        .then ->
          Db.seed
            flows: [
              { name: 'a' }
              { name: 'b' }
            ]
        .then ->
          Db.flows.select()
        .then Db.log
  ]
