require './controllers'
require './services'
seedData = require './db/seed'
schema = require './db/schema/'

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

      Db.ready ->
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
  ]

  .config [
    'DbProvider'
    (DbProvider) ->
      DbProvider.options.dbName = 'accountant'
      DbProvider.options.schema = schema
      DbProvider.options.logLevel = 'debug'
  ]

require './routes'
