class DbBase
  constructor: (@$cordovaSQLite, @$ionicPlatform, @$q, @queryBuilder, @options) ->
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
            @db = @$cordovaSQLite.openDB @options.dbName
            @connected = true
            @db.executeSql 'PRAGMA foreign_keys = ON'
            resolve()

  execute: (query, params) ->
    @$cordovaSQLite.execute @db, query, params
      .then (res) ->
        console.log "Success <#{query}>"
        res
      .catch (err) ->
        console.log "Error <#{query}>"
        throw err.message

  log: ->
    console.log JSON.stringify arguments

module.exports = DbBase
