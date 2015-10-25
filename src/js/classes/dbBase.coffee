class DbBase
  constructor: (@dbName, @$cordovaSQLite, @$ionicPlatform) ->
    @connected = false

  connect: ->
    unless @connected
      @$ionicPlatform.ready =>
        unless @connected
          @db = @$cordovaSQLite.openDB @dbName
          @connected = true
          @db.executeSql 'PRAGMA foreign_keys = ON'

  execute: (query, params) ->
    @$cordovaSQLite.execute @db, query, params

  log: ->
    console.log JSON.stringify arguments

module.exports = DbBase
