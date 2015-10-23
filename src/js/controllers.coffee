angular.module 'app.controllers', []

  .controller 'addCtrl', [
    '$scope'
    '$q'
    'Orm'
    ($scope, $q, Orm) ->
      $scope.wallets = [
        { id: 1, name: 'Карта', icon: 'ion-card', balance: '36 000' }
        { id: 2, name: 'Кошелек', icon: 'ion-cash', balance: '5 000' }
      ]

      # $scope.onSubmit = ->
      #   console.log 'submit'
      #
      # Db.connect()
      #   .then ->
      #     Db.dropTable 'a', true
      #   .then ->
      #     Db.createTable 'a', true
      #   .then ->
      #     Db.insertMultiple 'a', [ { id: 1 }, { id: 2 }, { id: 3 } ]
      #   .then ->
      #     Db.select 'a', where: { 7: { gte: 6 }, 2: { null: false } }
      #   .then (rows) ->
      #     console.log JSON.stringify rows

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
