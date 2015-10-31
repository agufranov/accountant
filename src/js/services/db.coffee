AccountantDb = require '../classes/accountantDb'

angular.module 'app.services'

  .provider 'Db', [
    ->
      options:
        dbName: null
        schema: null
        logLevel: 'debug'
        cachedTables: []

      $get: [
        '$cordovaSQLite'
        '$ionicPlatform'
        '$q'
        '$rootScope'
        'QueryBuilder'
        ($cordovaSQLite, $ionicPlatform, $q, $rootScope, QueryBuilder) ->
          db = new AccountantDb $cordovaSQLite, $ionicPlatform, $q, $rootScope, QueryBuilder, @options
      ]
  ]
