DbBase = require './dbBase'

class QueryHelper
  constructor: ->
    super arguments...
    @verbose = true

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
  createTable: (name, defs, ifNotExists = false) ->
    query = "CREATE TABLE"
    query += " IF NOT EXISTS" if ifNotExists is true
    query += " #{name} (#{defs.join ', '})"
    @execute query
      .then(
        (res) ->
          console.log "Success: CREATE TABLE #{name}", JSON.stringify res if @verbose
        ,
        (err) ->
          console.log "ERROR: CREATE TABLE #{name}" if @verbose
      )

  dropTable: (name, ifExists = false) ->
    query = "DROP TABLE"
    query += " IF EXISTS" if ifExists is true
    query += " #{name}"
    @execute query
      .then(
        (res) ->
          console.log "Success: DROP TABLE #{name}", JSON.stringify res if @verbose

        ,
        (err) ->
          console.log "ERROR: DROP TABLE #{name}" if @verbose
      )

  select: (tableName, options = {}, cols = '*') ->
    colsStr = if _.isArray cols then cols.join ', ' else cols
    query = "SELECT #{cols} FROM #{tableName}"
    query += ' ' + QueryHelper.whereToString options.where if options.where?
    query += " LIMIT #{options.limit}" if options.limit?
    @execute query
      .then(
        (res) ->
          console.log "Success: got #{res.rows.length} from <#{query}>" if @verbose
          console.log JSON.stringify res if @verbose
          (res.rows.item i for i in [0...res.rows.length])
        ,
        (err) ->
          console.log "ERROR: <#{query}>" if @verbose
      )

  insert: (tableName, o) ->
    colsStr = _.keys(o).join ', '
    qs = ('?' for i in [0..._.size o]).join ', '
    query = "INSERT INTO #{tableName} (#{colsStr}) VALUES (#{qs})"
    @execute query, _.values o
      .then(
        (res) ->
          console.log "Success: inserted #{res.rowsAffected} rows <#{query}>" if @verbose
          console.log JSON.stringify res if @verbose
          res
        ,
        (err) ->
          console.log "ERROR: <#{query}>" if @verbose
      )

  insertMultiple: (tableName, os) ->
    (@insert tableName, o for o in os)

module.exports = Db
