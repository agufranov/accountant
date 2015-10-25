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
        ($cordovaSQLite, $ionicPlatform) ->
          db = new DbWithSchema dbName, $cordovaSQLite, $ionicPlatform, schema
          db.verbose = false
          db
      ]
  ]
