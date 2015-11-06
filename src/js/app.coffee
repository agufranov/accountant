require './controllers'
require './services'
schema = require './db/schema/'

angular.module 'app', ['app.controllers', 'app.services', 'ionic', 'ngCordova']

  .run [
    '$ionicPlatform'
    ($ionicPlatform) ->
      $ionicPlatform.ready ->
        cordova?.plugins.Keyboard?.hideKeyboardAccessoryBar true
        StatusBar?.styleDefault()

      moment.locale 'ru'
  ]

  .config [
    'DbProvider'
    (DbProvider) ->
      _.extend DbProvider.options,
        dbName       : 'accountant'
        schema       : schema
        logLevel     : 'debug'
        cachedTables : ['wallets', 'places', 'types', 'sms_matchers']
        triggers     :
          flows: (Db) -> Db.updateWallets()
  ]

require './prepareDb'
require './routes'
require './filters'
