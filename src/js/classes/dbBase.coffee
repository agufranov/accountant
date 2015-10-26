class DbBase
  constructor: (@$cordovaSQLite, @$ionicPlatform, @$q, @queryBuilder, @options) ->
    @connected = false
    @options.logLevel ||= 'error'
    @logLevels = error: 1, debug: 2

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

  execute: (query, params, transaction) ->
    if transaction
      @debug "  + <#{query}>"
      transaction.executeSql query, params
    else
      @$cordovaSQLite.execute @db, query, params
        .then (res) =>
          @debug "Success <#{query}>"
          res
        .catch (err) =>
          @error "Error <#{query}>"
          throw err.message

  transaction: (fn) ->
    @debug 'Transaction start...'
    @$q (resolve, reject) =>
      @db.transaction(
        fn
        =>
          @error 'Transaction error'
          reject arguments...
        =>
          @debug 'Transaction success'
          resolve arguments...
      )

  log: (level, message) ->
    if @logLevels[level] <= @logLevels[@options.logLevel]
      console.log "[SQLite] (#{level}): #{message}"

  debug: (message) -> @log 'debug', message
  error: (message) -> @log 'error', message

module.exports = DbBase
