angular.module 'app.services'

  .factory 'QueryBuilder', [
    ->
      v = {
        conditionToString: (condition) ->
          return "= #{condition}" if _.isString condition
          return 'IS NULL' if condition.null is true
          return 'IS NOT NULL' if condition.null is false
          return "> #{condition.gt}" if condition.gt?
          return "< #{condition.lt}" if condition.lt?
          return ">= #{condition.gte}" if condition.gte?
          return "<= #{condition.lte}" if condition.lte?
          return "!= #{condition.neq}" if condition.neq?

        whereToString: (where) ->
          _.pairs where
            .map ([colName, condition]) ->
              "#{colName} #{v.conditionToString condition}"
            .join ' AND '

        makeQuery: (parts) ->
          _.filter parts
            .join ' '

        createTable: (tableName, options = {}) ->
          v.makeQuery [
            "CREATE TABLE"
            "IF NOT EXISTS" if options.ifNotExists
            tableName
            "(#{options.defs.join ', '})"
          ]

        dropTable: (tableName, options = {}) ->
          v.makeQuery [
            "DROP TABLE"
            "IF EXISTS" if options.ifExists
            tableName
          ]

        select: (tableName, options = {}) ->
          colsStr = if options.columns
            options.columns.join ', '
          else '*'
          v.makeQuery [
            "SELECT #{colsStr}"
            "FROM #{tableName}"
            "WHERE #{v.whereToString options.where}" if options.where?
            "LIMIT #{options.limit}" if options.limit?
          ]

        insert: (tableName, record, options = {}) ->
          keys = _.keys record
          colsStr = keys.join ', '
          qs = _.repeat '?', keys.length
          v.makeQuery [
            "INSERT INTO"
            tableName
            "(#{colsStr})"
            "VALUES"
            "(#{qs})"
          ]
      }
  ]
