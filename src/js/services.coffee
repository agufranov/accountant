angular.module 'app.services', []

  .factory 'Db', [
    '$cordovaSQLite'
    '$ionicPlatform'
    '$q'
    ($cordovaSQLite, $ionicPlatform, $q) ->
      readyQ = $q.defer()
      db = null
      $ionicPlatform.ready ->
        db = $cordovaSQLite.openDB { name: 'my' }
        readyQ.resolve()

      v =
        ready: ->
          readyQ.promise

        errCb: (name) ->
          ->
            console.log "SQLite error (#{name}):", JSON.stringify arguments

        dropIfExists: (table) ->
          $cordovaSQLite.execute db, "DROP TABLE IF EXISTS #{table}"

        insert: (table, o) ->
          columns = (key for key of o).join ', '
          questions = ('?' for key of o).join ', '
          values = (value for key, value of o)
          query = "INSERT INTO #{table} (#{columns}) VALUES (#{questions})"
          console.log query, values
          $cordovaSQLite.execute db, query, values

        select: (table, columns = '*', subquery = '') ->
          selectQ = $q.defer()
          $cordovaSQLite.execute db, "SELECT #{columns} FROM #{table} #{subquery}"
            .then (res) ->
              selectQ.resolve (res.rows.item(i) for i in [0...res.rows.length])
          selectQ.promise

        prepare: ->
          query = 'CREATE TABLE types(
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            parent_id INTEGER,
            FOREIGN KEY (parent_id) REFERENCES types(id)
          )'
          types = [
            { id: 1, name: 'Food' }
            { id: 2, name: 'Electronics' }
            { id: 3, name: 'Arduino', parent_id: 2 }
          ]

          p = v.dropIfExists 'types'
            .catch v.errCb 'drop'
            .then ->
              $cordovaSQLite.execute db, query
            .catch v.errCb 'create'

          for type in types
            p = p
              .then (
                ((_type) ->
                  ->
                    v.insert 'types', _type
                )(type)
              )
              .catch v.errCb "insert #{type.id}"

          p
            .then ->
              v.select 'types'
            .then (res) ->
              console.log 'final select', JSON.stringify res
  ]
