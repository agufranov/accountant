DbBase = require './dbBase'

class Db extends DbBase
  createTable: (tableName, defs, options = {}, transaction) ->
    query = @queryBuilder.createTable tableName, defs, options
    @execute query, [], transaction

  dropTable: (tableName, options = {}, transaction) ->
    query = @queryBuilder.dropTable tableName, options
    @execute query, [], transaction

  select: (tableName, options = {}, transaction) ->
    query = @queryBuilder.select tableName, options
    @execute query, [], transaction
      .then (res) ->
        res.rows.item i for i in [0...res.rows.length]

  insert: (tableName, record, options = {}, transaction) ->
    query = @queryBuilder.insert tableName, record, options
    @execute query, _.values(record), transaction

  insertMultiple: (tableName, records, options = {}, transaction) ->
    if transaction
      @insert tableName, record, options, transaction for record in records
    else
      @transaction (tx) =>
        @insert tableName, record, options, tx for record in records

module.exports = Db
