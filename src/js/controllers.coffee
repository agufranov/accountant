angular.module 'app.controllers', []

  .controller 'addCtrl', [
    '$scope'
    'Db'
    ($scope, Db) ->
      $scope.wallets = [
        { id: 1, name: 'Карта', icon: 'ion-card', balance: '36 000' }
        { id: 2, name: 'Кошелек', icon: 'ion-cash', balance: '5 000' }
      ]

      $scope.onSubmit = ->
        console.log 'submit'

      Db.ready().then ->
        console.log 'preparing'
        Db.prepare()
  ]
