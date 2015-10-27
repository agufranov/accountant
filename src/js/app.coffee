require './controllers'
require './services'
seedData = require './seed'

angular.module 'app', ['app.controllers', 'app.services', 'ionic', 'ngCordova']

  .run [
    '$ionicPlatform'
    '$q'
    'Db'
    'amMoment'
    'SMSParser'
    ($ionicPlatform, $q, Db, amMoment, SMSParser) ->
      $ionicPlatform.ready ->
        cordova?.plugins.Keyboard?.hideKeyboardAccessoryBar true
        StatusBar?.styleDefault()

      moment.locale 'ru'

      Db.connect()
        .then ->
          Db.execute 'PRAGMA foreign_keys'
        .then (res) ->
          console.log JSON.stringify res.rows.item(0)
        .then ->
          Db.resetTables()
        .then ->
          Db.seed seedData
        .then ->
          console.log 'Seed done!'
          Db.setPrepared()
      #     SMSParser.getMessagesFromNumber 900
      #       .then ->
      #         console.log JSON.stringify arguments
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
        sms_matchers:
          primaryKey: 'id'
          columns:
            id: type: 'INTEGER'
            number: type: 'TEXT', null: false
            matchFn: type: 'TEXT', null: false
            readFrom: type: 'INTEGER', null: false, default: '0'

      DbProvider.options.dbName = 'accountant'
      DbProvider.options.schema = schema
      DbProvider.options.logLevel = 'debug'
  ]
