angular.module 'app.controllers'

  .controller 'placesCtrl', [
    '$scope'
    'Db'
    ($scope, Db) ->
      $scope.findType = (type_id) ->
        _.find Db.cache.types, id: type_id
  ]
