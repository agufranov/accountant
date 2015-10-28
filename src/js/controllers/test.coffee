angular.module 'app.controllers'

  .controller 'testCtrl', [
    '$scope'
    'Db'
    ($scope, Db) ->
      Db.prepared ->
        Db.options.logLevel = 'debug'
        Db.test.insert data: 'Arr'
      .then ->
        Db.test.select()
      .then ->
        console.log JSON.stringify arguments
      .then ->
        Db.test.update { data: 'Bbb' }, { id: 1 }
      .then ->
        Db.test.select()
      .then ->
        console.log JSON.stringify arguments
  ]
