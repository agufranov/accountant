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
        ($cordovaSQLite, $ionicPlatform, $q) ->
          db = new DbWithSchema dbName, $cordovaSQLite, $ionicPlatform, $q, schema
          db.verbose = false
          db
      ]
  ]
