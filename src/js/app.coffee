require './controllers'
require './services'

angular.module 'app', ['app.controllers', 'app.services', 'ionic', 'ngCordova']

  .run [
    '$ionicPlatform'
    'Db'
    'amMoment'
    ($ionicPlatform, Db, amMoment) ->
      moment.locale 'ru'

      $ionicPlatform.ready ->
        cordova?.plugins.Keyboard?.hideKeyboardAccessoryBar true
        StatusBar?.styleDefault()

        Db.connect()
          .then ->
            Db.execute 'PRAGMA foreign_keys'
          .then (res) ->
            console.log JSON.stringify res.rows.item(0)
          .then ->
            Db.resetTables()
          .then ->
            Db.seed
              wallets: [
                { id: 1, name: 'Наличные', type: 'cash', balance: 0 }
                { id: 2, name: 'Карта', type: 'card', balance: 0 }
              ]
              types: [
                { id: 1, name: 'Кафе' }
                { id: 2, name: 'Рестораны' }
                { id: 3, name: 'Техника' }
                { id: 4, name: 'Arduino', parent_id: 3 }
                { id: 5, name: 'Одежда' }
              ]
            Db.seed
              flows: [
                { sum: 25000, source_id: 1, type_id: 1, date: moment().subtract('1', 'day').startOf('day').add('14', 'hours').unix() }
                { sum: 72000, source_id: 2, type_id: 4, date: moment().subtract('1', 'day').startOf('day').add('15', 'hours').unix() }
                { sum: 1200000, source_id: 2, type_id: 5, date: moment().subtract('1', 'day').startOf('day').add('21', 'hours').unix() }
                { sum: 32000, source_id: 1, type_id: 1, date: moment().subtract('2', 'hours').unix() }
                { sum: 47000, source_id: 2, type_id: 1, date: moment().subtract('1', 'hours').unix() }
              ]
          .then ->
            Db.flows.select()
          .then Db.log
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
              controller: 'mainCtrl'

        .state 'app.add',
          url: '/add'
          views:
            'menu-content':
              templateUrl: 'templates/add.html'
              controller: 'addCtrl'

      $urlRouterProvider.otherwise '/app/main'
  ]

  .config [
    'DbProvider'
    (DbProvider) ->
      schema =
        flows:
          primaryKey: 'id'
          columns:
            id: type: 'INTEGER'
            sum: type: 'INTEGER', null: false, check: "TYPEOF(sum) = 'integer' AND sum > 0"
            type_id: type: 'reference', table: 'types', null: false
            date: type: 'INTEGER', null: false, default: "(strftime('%s', 'now'))"
            comment: type: 'INTEGER', null: false, default: "''"
            source_id: type: 'reference', table: 'wallets', null: false
            dest_id: type: 'reference', table: 'wallets'
        wallets:
          primaryKey: 'id'
          columns:
            id: type: 'INTEGER'
            name: type: 'TEXT', null: false
            type: type: 'TEXT', null: false
            balance: type: 'INTEGER', null: false
        types:
          primaryKey: 'id'
          columns:
            id: type: 'INTEGER'
            name: type: 'TEXT', null: false
            parent_id: type: 'reference', table: 'types'

      DbProvider.setDbName 'accountant'
      DbProvider.setSchema schema
  ]
