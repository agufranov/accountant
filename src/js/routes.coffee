angular.module 'app'

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
          cache: false
          views:
            'menu-content':
              templateUrl: 'templates/main.html'
              controller: 'mainCtrl'

        .state 'app.flow',
          url: '/flows/:flowId'
          views:
            'menu-content':
              templateUrl: 'templates/flow.html'
              controller: 'flowCtrl'

        .state 'app.add',
          url: '/add'
          views:
            'menu-content':
              templateUrl: 'templates/add.html'
              controller: 'addCtrl'

        .state 'test',
          url: '/test'
          templateUrl: 'templates/test.html'
          controller: 'testCtrl'

        .state 'app.places',
          url: '/places'
          views:
            'menu-content':
              templateUrl: 'templates/places.html'
              controller: 'placesCtrl'

      $urlRouterProvider.otherwise '/app/main'
  ]
