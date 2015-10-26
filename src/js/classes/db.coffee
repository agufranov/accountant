DbBase = require './dbBase'

class Db extends DbBase
  createTable: (tableName, options = {}) ->
    query = @queryBuilder.createTable tableName, options
    @execute query

  dropTable: (tableName, options = {}) ->
    query = @queryBuilder.dropTable tableName, options
    @execute query

  select: (tableName, options) ->
    query = @queryBuilder.select tableName, options
    @execute query
      .then (res) ->
        res.rows.item i for i in [0...res.rows.length]

  insert: (tableName, record, options) ->
    query = @queryBuilder.insert tableName, record, options
    @execute query, _.values record

  insertMultiple: (tableName, os) ->
    @$q.all (@insert tableName, o for o in os)

module.exports = Db
