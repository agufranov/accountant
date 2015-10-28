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
      DbProvider.options.dbName = 'accountant'
      DbProvider.options.schema = schema
      DbProvider.options.logLevel = 'error'
  ]

require './prepareDb'
require './routes'
