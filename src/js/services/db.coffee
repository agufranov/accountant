DbWithSchema = require '../classes/dbWithSchema'

angular.module 'app.services'

  .provider 'Db', [
    ->
      options:
        dbName: null
        schema: null
        logLevel: 'debug'

      $get: [
        '$cordovaSQLite'
        '$ionicPlatform'
        '$q'
        'QueryBuilder'
        ($cordovaSQLite, $ionicPlatform, $q, QueryBuilder) ->
          db = new DbWithSchema $cordovaSQLite, $ionicPlatform, $q, QueryBuilder, @options
      ]
  ]
