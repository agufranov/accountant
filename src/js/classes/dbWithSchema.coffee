Db = require './db'

class DbWithSchema extends Db
  constructor: (dbName, $cordovaSQLite, $ionicPlatform, @schema) ->
    super dbName, $cordovaSQLite, $ionicPlatform
    for tableName of @schema
      @[tableName] = new Table @, tableName

class Table
  constructor: (@db, @name) ->
    @def = @db.schema[@name]

    for operation in [
      'dropTable'
      'select'
      'insert'
      'insertMultiple'
    ]
      @[operation] = _.partial @db[operation], @name
        .bind @db

  getDefs: ->
    defStrs = []
    for colName, colDef of @def.columns
      defStr = "#{colName} #{colDef.type}"
      defStr += " PRIMARY KEY" if colName is @def.primaryKey
      defStr += " NOT NULL" if colDef.null is false
      defStrs.push defStr
    defStrs

  createTable: (ifNotExists) ->
    @db.createTable @name, @getDefs(), ifNotExists

module.exports = DbWithSchema
