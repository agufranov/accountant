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
          Db.execute 'PRAGMA foreign_keys'
        .then (res) ->
          console.log JSON.stringify res.rows.item(0)
        .then ->
          Db.resetTables()
        .then ->
          Db.seed
            wallets: [
              { id: 1, name: 'Наличные', type: 'cash', balance: 0 }
              { id: 2, name: 'Карта', type: 'card', balance: 0 }
            ]
          Db.seed
            flows: [
              { sum: 2, source_id: 2 }
            ]
        .then ->
          Db.flows.select()
        .then Db.log
  ]
