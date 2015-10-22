require './controllers'

angular.module 'app', ['app.controllers', 'ionic', 'ngCordova']

  .run [
    '$ionicPlatform'
    ($ionicPlatform) ->
      $ionicPlatform.ready ->
        cordova?.plugins.Keyboard?.hideKeyboardAccessoryBar true
        StatusBar?.styleDefault()
  ]

  .config [
    '$stateProvider'
    '$urlRouterProvider'
    ($stateProvider, $urlRouterProvider) ->
      $stateProvider

        .state 'app',
          url: '/app'
          abstract: true
          templateUrl: 'templates/menu.html'

        .state 'app.main',
          url: '/main'
          views:
            'menu-content':
              templateUrl: 'templates/main.html'

        .state 'app.add',
          url: '/add'
          views:
            'menu-content':
              templateUrl: 'templates/add.html'
              controller: 'addCtrl'

      $urlRouterProvider.otherwise '/app/add'
  ]
