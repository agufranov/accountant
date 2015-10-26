Db = require './db'

class DbWithSchema extends Db
  constructor: ($cordovaSQLite, $ionicPlatform, $q, queryBuilder, options) ->
    super arguments...
    @tables = {}
    for tableName of @options.schema
      @[tableName] = @tables[tableName] = new Table @, tableName

  createTables: (options) ->
    qs = []
    for tableName, table of @tables
      qs.push table.createTable options
    @$q.all qs

  resetTables: ->
    qs = []
    for tableName, table of @tables
      qs.push(
        table.dropTable ifExists: true
          .then do (table) ->
            ->
              table.createTable()
      )
    @$q.all qs

  seed: (data) ->
    @transaction (tx) =>
      for tableName, records of data
        if (table = @tables[tableName])
          table.insertMultiple records, {}, tx

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
        
      defStr = @db.queryBuilder.makeQuery [
        "#{colName} #{colType}"
        "PRIMARY KEY" if colName is @def.primaryKey
        "NOT NULL" if colDef.null is false
        "CHECK (#{colDef.check})" if colDef.check
        "DEFAULT #{colDef.default}" if colDef.default
      ]
      defStrs.push defStr
    defStrs.concat fkStrs

  createTable: (options) ->
    @db.createTable @name, @getDefs(), options

module.exports = DbWithSchema
