Orm = require '../classes/orm'

angular.module 'app.services'

  .provider 'Orm', [
    'DbProvider'
    (DbProvider) ->
      schema = null

      setSchema: (value) -> schema = value
      $get: [
        ->
          new Orm DbProvider, schema
      ]
  ]
