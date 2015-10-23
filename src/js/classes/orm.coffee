class Orm
  constructor: (@db, @schema) ->
    for tableName of @schema
      @[tableName] = new Table @, tableName

class Table
  constructor: (@orm, @name) ->
    @def = @orm.schema[@name]
    console.log JSON.stringify @def

module.exports = Orm
