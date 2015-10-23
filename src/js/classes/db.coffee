DbBase = require './dbBase'

class QueryHelper
  @conditionToString: (condition) ->
    return "= #{condition}" if _.isString condition
    return 'IS NULL' if condition.null is true
    return 'IS NOT NULL' if condition.null is false
    return "> #{condition.gt}" if condition.gt?
    return "< #{condition.lt}" if condition.lt?
    return ">= #{condition.gte}" if condition.gte?
    return "<= #{condition.lte}" if condition.lte?
    return "!= #{condition.neq}" if condition.neq?
      

  @whereToString: (where) ->
    'WHERE ' +
    _.pairs where
      .map ([colName, condition]) ->
        "#{colName} #{QueryHelper.conditionToString condition}"
      .join ' AND '

class Db extends DbBase
  constructor: (dbName, $cordovaSQLite, $ionicPlatform) ->
    super dbName, $cordovaSQLite, $ionicPlatform

  createTable: (name, ifNotExists = false) ->
    query = "CREATE TABLE"
    query += " IF NOT EXISTS" if ifNotExists is true
    query += " #{name} (id integer primary key)"
    @execute query
      .then(
        (res) ->
          console.log "Success: CREATE TABLE #{name}", JSON.stringify res
        ,
        (err) ->
          console.log "ERROR: CREATE TABLE #{name}"
      )

  dropTable: (name, ifExists = false) ->
    query = "DROP TABLE"
    query += " IF EXISTS" if ifExists is true
    query += " #{name}"
    @execute query
      .then(
        (res) ->
          console.log "Success: DROP TABLE #{name}", JSON.stringify res

        ,
        (err) ->
          console.log "ERROR: DROP TABLE #{name}"
      )

  select: (tableName, options = {}, cols = '*') ->
    colsStr = if _.isArray cols then cols.join ', ' else cols
    query = "SELECT #{cols} FROM #{tableName}"
    query += ' ' + QueryHelper.whereToString options.where if options.where?
    @execute query
      .then(
        (res) ->
          console.log "Success: got #{res.rows.length} from <#{query}>"
          console.log JSON.stringify res
          (res.rows.item i for i in [0...res.rows.length])
        ,
        (err) ->
          console.log "ERROR: <#{query}>"
      )

  insert: (tableName, o) ->
    colsStr = _.keys(o).join ', '
    qs = ('?' for i in [0..._.size o]).join ', '
    query = "INSERT INTO #{tableName} (#{colsStr}) VALUES (#{qs})"
    @execute query, _.values o
      .then(
        (res) ->
          console.log "Success: inserted #{res.rowsAffected} rows <#{query}>"
          console.log JSON.stringify res
          res
        ,
        (err) ->
          console.log "ERROR: <#{query}>"
      )

  insertMultiple: (tableName, os) ->
    (@insert tableName, o for o in os)

module.exports = Db
