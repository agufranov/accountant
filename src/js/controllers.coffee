Orm = require './orm'

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

      $scope.onSubmit = ->
        console.log 'submit'

      Db.connect()
        .then ->
          Db.dropTable 'a', true
        .then ->
          Db.createTable 'a', true
        .then ->
          Db.insert 'a', id: 1
        .then ->
          Db.select 'a', where: { '1': 1 }
        .then (rows) ->
          console.log JSON.stringify rows

      # orm = new Orm
      #   users:
      #     primaryKey: 'id'
      #     columns:
      #       id: type: 'integer'
      #       name: type: 'text', null: false
      #
      #   posts:
      #     primaryKey: 'id'
      #     columns:
      #       id: type: 'integer'
      #       body: type: 'text', null: false
      #       user_id: type: 'reference', table: 'users'
      #   , Db
      #   
      # Db.ready()
      #   .then ->
      #     orm.posts.dropTable()
      #   .then ->
      #     orm.users.dropTable()
      #   .then ->
      #     orm.users.createTable()
      #   .then ->
      #     orm.posts.createTable()
      #   .then ->
      #     Db.execute 'SELECT * FROM sqlite_master'
      #   .then (res) ->
      #     console.log JSON.stringify res
      #   .then ->
      #     $q.all( [
      #       { body: 'a' }
      #       { body: 'b' }
      #       { id: 65, body: 'c' }
      #     ]
      #       .map (o) -> orm.posts.insert o
      #     )
      #   .then ->
      #     orm.posts.select()
      #   .then (res) ->
      #     console.log JSON.stringify res
      #   .catch ->
      #     console.log JSON.stringify arguments
  ]
