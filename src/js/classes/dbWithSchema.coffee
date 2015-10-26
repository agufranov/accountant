Db = require './db'

class DbWithSchema extends Db
  constructor: ($cordovaSQLite, $ionicPlatform, $q, queryBuilder, options) ->
    super arguments...
    @tables = {}
    for tableName of @options.schema
      @[tableName] = @tables[tableName] = new Table @, tableName

  createTables: (ifNotExists = false) ->
    for tableName, table of @tables
      table.createTable ifNotExists

  resetTables: ->
    for tableName, table of @tables
      table.dropTable true
      table.createTable()

  seed: (data) ->
    qs = []
    for tableName, records of data
      qs.push(table.insertMultiple records) if (table = @tables[tableName])
    @$q.all qs

class Table
  constructor: (@db, @name) ->
    @def = @db.options.schema[@name]

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
        refTableDef = @db.options.schema[refTableName]
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
    console.log result if @verbose #!!!!!!! TODO
    result

  createTable: (ifNotExists) ->
    @db.createTable @name, @getDefs(), ifNotExists

module.exports = DbWithSchema
