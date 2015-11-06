Db = require './db'

class DbWithSchema extends Db
  constructor: ($cordovaSQLite, $ionicPlatform, $q, $rootScope, queryBuilder, options) ->
    super arguments...
    @preparedQ = @$q.defer()
    @tables = {}
    for tableName of @options.schema
      @[tableName] = @tables[tableName] = new Table @, tableName

  createTables: (options) ->
    @transaction (tx) =>
      for tableName, table of @tables
        table.createTable options, tx

  dropTables: (options) ->
    @transaction (tx) =>
      for tableName, table of @tables
        table.dropTable options, tx

  resetTables: ->
    @dropTables ifExists: true
      .then =>
        @createTables()

  seed: (data) ->
    @transaction (tx) =>
      for tableName, records of data
        if (table = @tables[tableName])
          table.insertMultiple records, {}, tx

  info: ->
    for tableName, table of @tables
      table.select()
        .then do (tableName) ->
          (rows) ->
            console.log "Table #{tableName} contains #{rows.length} rows"

  prepared: (cb) ->
    @preparedQ.promise.then cb

  setPrepared: ->
    @initCache()
      .then => @preparedQ.resolve()

  snapshot: (tableNames) ->
    snapshot = {}
    qs = []
    for tableName, table of _.pick @tables, tableNames
      q = table.select().then do (tableName) ->
        (items) ->
          snapshot[tableName] = items
      qs.push q
    @$q.all qs
      .then -> snapshot

  initCache: ->
    @$rootScope.$on 'db:changed', (event, data) =>
      tablesToReload = _.intersection data.tables, @options.cachedTables
      console.log 'DB changed', JSON.stringify tablesToReload
      @snapshot tablesToReload
        .then (snapshot) =>
          _.extend @cache, snapshot
      for table in data.tables
        trigger @ if (trigger = @options.triggers?[table])

    @snapshot @options.cachedTables
      .then (snapshot) =>
        @$rootScope.cache = @cache = snapshot

class Table
  constructor: (@db, @name) ->
    @def = @db.options.schema[@name]

    for operation in [
      'dropTable'
      'select'
      'insert'
      'insertMultiple'
      'update',
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
