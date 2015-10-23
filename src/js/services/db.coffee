Db = require '../classes/db'

angular.module 'app.services'

  .provider 'Db', [
    ->
      dbName = null

      setDbName: (value) -> dbName = value
      $get: [
        '$cordovaSQLite'
        '$ionicPlatform'
        ($cordovaSQLite, $ionicPlatform) ->
          new Db dbName, $cordovaSQLite, $ionicPlatform
      ]
  ]
