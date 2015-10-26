class DbBase
  constructor: (@dbName, @$cordovaSQLite, @$ionicPlatform, @$q) ->
    @connected = false

  connect: ->
    @$q (resolve, reject) =>
      if @connected
        resolve()
      else
        @$ionicPlatform.ready =>
          if @connected
            resolve()
          else
            @db = @$cordovaSQLite.openDB @dbName
            @connected = true
            @db.executeSql 'PRAGMA foreign_keys = ON'
            resolve()

  execute: (query, params) ->
    @$cordovaSQLite.execute @db, query, params

  log: ->
    console.log JSON.stringify arguments

module.exports = DbBase
