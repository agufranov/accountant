angular.module 'app.controllers'

  .filter 'fin', ->
    (input) ->
      (input / 100).toFixed 2
