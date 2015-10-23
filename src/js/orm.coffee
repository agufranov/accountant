class Orm
  constructor: (@schema, @sqlite) ->
    for tableName, tableDef of @schema
      console.log tableName
      @[tableName] = new Table @, tableName

class Table
  constructor: (@orm, @name) ->
    @def = @orm.schema[@name]
    console.log @createQuery()

  createQuery: ->
    colDefs = (@colDefToSql @def, colName for colName of @def.columns)
    sqls = colDefs
      .map (cd) -> cd.sql
    fkSqls = colDefs
      .map (cd) -> cd.fkSql
      .filter (sql) -> sql isnt undefined
    colSqls = sqls.concat fkSqls
      .join ', '
    "CREATE TABLE #{@name} (#{colSqls})"

  createTable: ->
    @orm.sqlite.execute @createQuery()

  dropTable: ->
    @orm.sqlite.execute "DROP TABLE IF EXISTS #{@name}"

  insert: (o) ->
    cols = _.keys(o).join ', '
    qs = ('?' for i in [0..._.size(o)]).join ', '
    query = "INSERT INTO #{@name} (#{cols}) VALUES (#{qs})"
    console.log query
    @orm.sqlite.execute query, _.values o

  select: (cols = '*') ->
    colsSql = if _.isArray cols then cols.join ', ' else cols
    query = "SELECT #{cols} FROM #{@name}"
    @orm.sqlite.execute query
      .then (res) ->
        (res.rows.item i for i in [0...res.rows.length])

  colDefToSql: (tableDef, colName) ->
    colDef = tableDef.columns[colName]
    sql = []
    colType = if colDef.type isnt 'reference'
      colDef.type
    else
      refTableDef = @orm.schema[colDef.table]
      refCol = refTableDef.columns[refTableDef.primaryKey]
      fkSql = "FOREIGN KEY(#{colName}) REFERENCES #{colDef.table}(#{refTableDef.primaryKey})"
      refCol.type

    sql = "#{colName} #{colType}"
    sql += " NOT NULL" if colDef.null is false
    sql += " PRIMARY KEY" if tableDef.primaryKey is colName
    { sql, fkSql }

module.exports = Orm
