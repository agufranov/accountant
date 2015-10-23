require './controllers'
require './services'

angular.module 'app', ['app.controllers', 'app.services', 'ionic', 'ngCordova']

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

  .config [
    'DbProvider'
    (DbProvider) ->
      DbProvider.setDbName 'accountant'
  ]

  .config [
    'OrmProvider'
    (OrmProvider) ->
      schema =
        users:
          primaryKey: 'id'
          columns:
            id: type: 'integer'
            name: type: 'text', null: false
        posts:
          primaryKey: 'id'
          columns:
            id: type: 'integer'
            body: type: 'text', null: false
            user_id: type: 'reference', table: 'users'

      OrmProvider.setSchema schema
  ]
