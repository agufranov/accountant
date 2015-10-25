Db = require './db'

class DbWithSchema extends Db
  constructor: (dbName, $cordovaSQLite, $ionicPlatform, @schema) ->
    super dbName, $cordovaSQLite, $ionicPlatform
    @tables = {}
    for tableName of @schema
      @[tableName] = @tables[tableName] = new Table @, tableName

  createTables: (ifNotExists = false) ->
    for tableName, table of @tables
      table.createTable ifNotExists

  resetTables: ->
    for tableName, table of @tables
      table.dropTable true
      table.createTable()

  seed: (data) ->
    for tableName, records of data
      table.insertMultiple records if (table = @tables[tableName])

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
    fkStrs = []
    for colName, colDef of @def.columns
      colType = null
      
      if colDef.type isnt 'reference'
        colType = colDef.type
      else
        refTableName = colDef.table
        refTableDef = @db.schema[refTableName]
        refPk = refTableDef.primaryKey
        colType = refTableDef.columns[refPk].type
        fkStrs.push "FOREIGN KEY(#{colName}) REFERENCES #{refTableName}(#{refPk})"
        
      defStr = "#{colName} #{colType}"
      defStr += " PRIMARY KEY" if colName is @def.primaryKey
      defStr += " NOT NULL" if colDef.null is false
      defStr += " CHECK (#{colDef.check})" if colDef.check
      defStr += " DEFAULT #{colDef.default}" if colDef.default
      defStrs.push defStr
    result = defStrs.concat fkStrs
    console.log result
    result

  createTable: (ifNotExists) ->
    @db.createTable @name, @getDefs(), ifNotExists

module.exports = DbWithSchema
