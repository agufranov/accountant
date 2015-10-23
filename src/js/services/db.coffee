angular.module 'app.services'

  .provider 'Db', [
    ->
      dbName = null

      setDbName: (value) -> dbName = value
      $get: [
        '$cordovaSQLite'
        '$ionicPlatform'
        ($cordovaSQLite, $ionicPlatform) ->
          connect: ->
            $ionicPlatform.ready =>
              @db = $cordovaSQLite.openDB dbName

          execute: (query, params) ->
            $cordovaSQLite.execute @db, query, params

          log: ->
            console.log JSON.stringify arguments

          logRows: (res) ->
            console.log "Result: #{res.rows.length} rows"
            console.log res.rows.item(i) for i in [0...res.rows.length]
      ]
  ]
