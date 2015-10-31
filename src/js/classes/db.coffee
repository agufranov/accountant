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
    exec = @execute query, _.values(record), transaction
    if transaction
      @constructor.addTransactionImpact transaction, tableName
    else
      exec.then => @notifyChanged tableName

  insertMultiple: (tableName, records, options = {}, transaction) ->
    if transaction
      @insert tableName, record, options, transaction for record in records
    else
      @transaction (tx) =>
        @insert tableName, record, options, tx for record in records

  update: (tableName, o, options = {}, transaction) ->
    query = @queryBuilder.update tableName, o, options
    exec = @execute query, _.values(o), transaction
    if transaction
      @constructor.addTransactionImpact transaction, tableName
    else
      exec.then => @notifyChanged tableName

  @addTransactionImpact: (transaction, tableName) ->
    (transaction.impact ||= []).push tableName

module.exports = Db
