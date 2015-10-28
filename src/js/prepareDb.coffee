seedData = require './db/seed'

angular.module 'app'

  .run [
    'Db'
    'SMSParser'
    (Db, SMSParser) ->
      Db.ready ->
        Db.execute 'PRAGMA foreign_keys'
      .then (res) ->
        console.log JSON.stringify res.rows.item(0)
      .then ->
        Db.resetTables()
      .then ->
        Db.seed seedData
      .then ->
        console.log 'Seed done!'
        SMSParser.go()
      .then ->
        Db.setPrepared()

  ]
