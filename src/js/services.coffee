angular.module 'app.services', []

  .factory 'Db', [
    '$cordovaSQLite'
    '$ionicPlatform'
    '$q'
    ($cordovaSQLite, $ionicPlatform, $q) ->
      readyQ = $q.defer()
      db = null
      $ionicPlatform.ready ->
        db = $cordovaSQLite.openDB { name: 'my' }
        readyQ.resolve()

      ready: ->
        readyQ.promise

      get: ->
        $cordovaSQLite.execute db, 'SELECT * FROM sqlite_master', []
          .then (res) ->
            console.log 'success', JSON.stringify arguments
          , (err) ->
            console.log 'err', JSON.stringify arguments
  ]
