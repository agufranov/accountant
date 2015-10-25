class DbBase
  constructor: (@dbName, @$cordovaSQLite, @$ionicPlatform) ->

  connect: ->
    @$ionicPlatform.ready =>
      @db = @$cordovaSQLite.openDB @dbName
      @db.executeSql 'PRAGMA foreign_keys = ON'

  execute: (query, params) ->
    @$cordovaSQLite.execute @db, query, params

  log: ->
    console.log JSON.stringify arguments

module.exports = DbBase
