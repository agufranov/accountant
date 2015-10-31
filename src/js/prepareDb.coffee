seedData = require './db/seed'

angular.module 'app'

  .run [
    '$rootScope'
    'Db'
    'SMSParser'
    ($rootScope, Db, SMSParser) ->
      Db.ready ->
      #   Db.execute 'PRAGMA foreign_keys'
      # .then (res) ->
      #   console.log JSON.stringify res.rows.item(0)
      # .then ->
      #   Db.resetTables()
      # .then ->
      #   Db.seed seedData
      # .then ->
      #   console.log 'Seed done!'
      #   SMSParser.go()
      # .then ->
        $rootScope.$on 'db:changed', (event, data) ->
          console.log 'DB changed', JSON.stringify data
          Db.snapshot data.tables
            .then (snapshot) ->
              _.extend $rootScope, snapshot

        Db.snapshot ['wallets', 'places', 'types', 'sms_matchers']
      .then (snapshot) ->
        _.extend $rootScope, snapshot
        Db.setPrepared()

  ]
