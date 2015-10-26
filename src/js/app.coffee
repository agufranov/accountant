require './controllers'
require './services'

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
        # .then -> Db.execute 'PRAGMA foreign_keys'
        # .then (res) ->
        #   console.log JSON.stringify res.rows.item(0)

        # .then -> Db.insert 'test', { data: 'waer' }

              # setTimeout ->
              #   tx.executeSql 'INSERT INTO test(ata) VALUES (?)', ['4']
              # , 10
        .then -> Db.dropTable 'test', ifExists: true
        .then -> Db.createTable 'test', defs: [ 'id integer primary key', 'data text' ]
        # .then ->
        #   Db.transaction (tx) ->
        #     Db.insert 'test', { data: 'Alice' }, transaction: tx
        #     Db.insert 'test', { daa: 'Bob' }, transaction: tx
        #     Db.insert 'test', { data: 'Charley' }, transaction: tx
        .then ->
          Db.transaction (tx) ->
            Db.insertMultiple 'test', [
              { data: 'Alice' }
              { data: 'Bob' }
              { data: 'Charley' }
            ], {}, tx
            Db.insert 'test', { data: 'Bravo!' }, {}, tx
        .then(
          ->
            Db.select 'test', { columns: ['id', 'data'], where: { id: { gte: 1 } }, limit: 15 }
          ->
            Db.select 'test', { columns: ['id', 'data'], where: { id: { gte: 1 } }, limit: 15 }
        )
        .then (rows) -> console.log JSON.stringify rows
        # .then -> Db.select 'test'
        # .then (res) ->
        #   console.log JSON.stringify res

      # Db.connect()
      #   .then ->
      #     Db.execute 'PRAGMA foreign_keys'
      #   .then (res) ->
      #     console.log JSON.stringify res.rows.item(0)
      #   .then ->
      #     Db.resetTables()
      #   .then ->
      #     Db.seed
      #       wallets: [
      #         { id: 1, name: 'Наличные', type: 'cash', balance: 0 }
      #         { id: 2, name: 'Карта', type: 'card', balance: 0 }
      #       ]
      #       types: [
      #         { id: 0, name: '<N/A>' }
      #         { id: 1, name: 'Кафе' }
      #         { id: 2, name: 'Рестораны' }
      #         { id: 3, name: 'Техника' }
      #         { id: 4, name: 'Arduino', parent_id: 3 }
      #         { id: 5, name: 'Одежда' }
      #       ]
      #       sms_matchers: [
      #         {
      #           number: 900
      #           matchFn: '(' + ((message) ->
      #             matches = message.body.match /^(\w+) (\d{2}\.\d{2}\.\d{2} \d{2}:\d{2}) ([^\d]+) ([\d\.]+)р (.*) Баланс: ([\d\.]+)р$/
      #             if matches
      #               [all, card, dateRaw, operationRaw, sumRaw, place, balanceRaw] = matches
      #               return {
      #                 card
      #                 date: moment(dateRaw, 'DD.MM.YYYY HH:mm:ss')
      #                 operation: { 'покупка': 'payment', 'выдача наличных': 'cashOut', 'зачисление': 'cashIn' }[operationRaw]
      #                 sum: Math.round sumRaw * 100
      #                 place
      #                 balance: Math.round balanceRaw * 100
      #               }
      #             else
      #               null
      #           ).toString() + ')'
      #         }
      #       ]
      #       sms: [
      #       ]
      #   .then ->
      #     Db.seed
      #       flows: [
      #         { sum: 25000, source_id: 1, type_id: 1, date: moment().subtract('1', 'day').startOf('day').add('14', 'hours').unix() }
      #         { sum: 72000, source_id: 2, type_id: 4, date: moment().subtract('1', 'day').startOf('day').add('15', 'hours').unix() }
      #         { sum: 1200000, source_id: 2, type_id: 5, date: moment().subtract('1', 'day').startOf('day').add('21', 'hours').unix() }
      #         { sum: 32000, source_id: 1, type_id: 1, date: moment().subtract('2', 'hours').unix() }
      #         { sum: 47000, source_id: 2, type_id: 1, date: moment().subtract('1', 'hours').unix() }
      #       ]
      #   .then ->
      #     console.log 'Seed!'
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
  ]
