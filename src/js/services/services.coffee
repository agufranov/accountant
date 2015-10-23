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
          $cordovaSQLite.execute db, query, values

        select: (table, columns = '*', subquery = '') ->
          selectQ = $q.defer()
          $cordovaSQLite.execute db, "SELECT #{columns} FROM #{table} #{subquery}"
            .then (res) ->
              selectQ.resolve (res.rows.item(i) for i in [0...res.rows.length])
          selectQ.promise

        execute: (query, params) ->
          $cordovaSQLite.execute db, query, params

        prepare: ->
          flowsCreateQuery = 'CREATE TABLE flows(
            id INTEGER PRIMARY KEY,
            sum INTEGER NOT NULL,
            type_id INTEGER,
            source_id INTEGER NOT NULL,
            destination_id INTEGER,
            date INTEGER NOT NULL,
            FOREIGN KEY (type_id) REFERENCES types(id),
            FOREIGN KEY (source_id) REFERENCES wallets(id),
            FOREIGN KEY (destination_id) REFERENCES wallets(id)
          )'

          typesCreateQuery = 'CREATE TABLE types(
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            parent_id INTEGER,
            FOREIGN KEY (parent_id) REFERENCES types(id)
          )'

          walletsCreateQuery = 'CREATE TABLE wallets(
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            type INTEGER NOT NULL,
            balance INTEGER NOT NULL
          )'

          # recreate tables
          v.dropIfExists 'flows'
            .catch v.errCb 'drop flows'
            .then ->
              console.log 'Flows dropped'
              v.dropIfExists 'types'
            .catch v.errCb 'drop types'
            .then ->
              console.log 'Types dropped'
              v.dropIfExists 'wallets'
            .catch v.errCb 'drop wallets'
            .then ->
              console.log 'Wallets dropped'
              $cordovaSQLite.execute db, typesCreateQuery
            .catch v.errCb 'create types'
            .then ->
              console.log 'Types created'
              $cordovaSQLite.execute db, walletsCreateQuery
            .catch v.errCb 'create wallets'
            .then ->
              console.log 'Wallets created'
              $cordovaSQLite.execute db, flowsCreateQuery
            .catch v.errCb 'create flows'
            .then ->
              console.log 'Flows created'

              seed = (table, data) ->
                $q.all(
                  data.map (record) ->
                    v.insert table, record
                )
                  .catch v.errCb "insert #{table}"
                  .then ->
                    console.log "#{table} seeded"
                    v.select table
                  .then (res) ->
                    console.log "#{table} data:", JSON.stringify res

              # seed types
              types = [
                { id: 1, name: 'Food' }
                { id: 2, name: 'Electronics' }
                { id: 3, name: 'Arduino', parent_id: 2 }
              ]

              # seed wallets
              wallets = [
                { id: 1, name: 'Card', type: 0, balance: 0 }
                { id: 2, name: 'Cash', type: 1, balance: 0 }
              ]

              # seed flows
              flows = [
                { id: 1, sum: 50000, type_id: 1, source_id: 1, date: Date.now() }
              ]

              seed 'types', types
              seed 'wallets', wallets
              seed 'flows', flows
  ]
