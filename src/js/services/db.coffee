DbWithSchema = require '../classes/dbWithSchema'

angular.module 'app.services'

  .provider 'Db', [
    ->
      dbName = null
      schema = null

      setDbName: (value) -> dbName = value
      setSchema: (value) -> schema = value
      $get: [
        '$cordovaSQLite'
        '$ionicPlatform'
        '$q'
        'QueryBuilder'
        ($cordovaSQLite, $ionicPlatform, $q, QueryBuilder) ->
          db = new DbWithSchema $cordovaSQLite, $ionicPlatform, $q, QueryBuilder, {
            dbName: dbName
            schema: schema
            verbose: false
          }
      ]
  ]
