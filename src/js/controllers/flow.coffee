angular.module 'app.controllers'

  .controller 'flowCtrl', [
    '$scope'
    '$stateParams'
    '$ionicModal'
    '$ionicHistory'
    '$cordovaToast'
    'Db'
    ($scope, $routeParams, $ionicModal, $ionicHistory, $cordovaToast, Db) ->
      id = $routeParams.flowId
      Db.prepared ->
        Db.flows.select where: id: id
      .then (flows) ->
        $scope.flow = flows[0]

        findType = -> $scope.flow_type = _.find Db.cache.types, { id: $scope.flow.type_id }
        findType()

        $scope.$watch 'flow.type_id', (newValue, oldValue) ->
          if newValue isnt oldValue
            findType()
            $scope.type_dirty = true

        $scope.type_dirty = false

        $scope.save = ->
          Db.flows.update _.pick($scope.flow, 'type_id'), where: id: $scope.flow.id
            .then(
              ->
                $cordovaToast.showShortCenter 'Flow saved'
                $ionicHistory.goBack()
              -> $cordovaToast.showLongCenter 'Error saving flow'
            )

      $scope.showModal = ->
        $ionicModal.fromTemplateUrl 'templates/typeModal.html', scope: $scope
          .then (modal) ->
            $scope.modal = modal
            modal.show()

      $scope.closeModal = ->
        $scope.modal.remove()
  ]
