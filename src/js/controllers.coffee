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

      flows = Db.flows
      Db.connect()
        .then ->
          flows.dropTable true
        .then ->
          flows.createTable()
        .then ->
          flows.insertMultiple [
            { name: 'a' }
            { name: 'b' }
          ]
        .then ->
          flows.select()
        .then Db.log
  ]
