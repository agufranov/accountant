angular.module 'app.controllers'

  .controller 'addCtrl', [
    '$scope'
    'Db'
    ($scope, Db) ->
      Db.prepared ->
        Db.snapshot ['wallets', 'types']
          .then (snapshot) ->
            console.log JSON.stringify snapshot
  ]
