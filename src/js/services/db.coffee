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
          new DbWithSchema dbName, $cordovaSQLite, $ionicPlatform, schema
      ]
  ]
