angular.module 'app.controllers'

  .controller 'flowCtrl', [
    '$scope'
    '$stateParams'
    'Db'
    ($scope, $routeParams, Db) ->
      id = $routeParams.flowId
      Db.ready ->
        Db.flows.select where: id: id
      .then (flows) ->
        $scope.flow = flows[0]
  ]
