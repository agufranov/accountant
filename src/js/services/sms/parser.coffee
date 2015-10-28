angular.module 'app.services'

  .factory 'SMSParser', [
    '$ionicPlatform'
    '$q'
    'Db'
    ($ionicPlatform, $q, Db) ->
      class MessageProvider
        constructor: (@matcher) ->

        getMessages: ->
          $q (resolve, reject) =>
            SMS.listSMS {
              address: @matcher.number
              maxCount: 10000
              indexFrom: @matcher.readFrom
            }, (messages) ->
              resolve messages

      class Parser
        constructor: ->

        init: ->
          Db.connect()
            .then ->
              Db.sms_matchers.select()
            .then (matchers) =>
              @matchers = matchers

        getMessagesFromNumber: (number) ->
          matcher = _.find @matchers, number: number.toString()
          console.log JSON.stringify @matchers
          messageProvider = new MessageProvider matcher
          messageProvider.getMessages()
            .then (messages) ->
              parsedMessages = _ messages
                .map eval matcher.matchFn
                .filter()
                .value()

      go: ->
        Db.ready ->
          Db.sms_matchers.select()
        .then (matchers) ->
          for matcher in matchers
            new MessageProvider matcher
              .getMessages()
              .then (messages) ->
                console.log JSON.stringify message for message in messages
                maxMessageId = _.max(messages, '_id')._id
                console.log maxMessageId
                return
                parsedMessages = _ messages
                  .map eval matcher.matchFn
                  .filter()
                  .value()
                flows = parsedMessages.map messageToFlow
                Db.transaction (tx) ->
                  Db.flows.insertMultiple flows, {}, tx
                  Db.sms_matchers.update
          

      # getMatchers: ->
      #   $q (resolve, reject) =>
      #     Db.connect()
      #       .then ->
      #         Db.sms_matchers.select()
      #       .then (matchers) =>
      #         resolve matchers
      #
      # getMessages: (matchers) ->
      #   $q (resolve, reject) =>
      #     numbers = _.map matchers, 'number'
      #     qs = []
      #     for number in numbers
      #       qs.push $q (resolveChunk, rejectChunk) ->
      #         SMS.listSMS { address: number, maxCount: 100000 }, (messages) ->
      #           resolveChunk messages
      #     $q.all qs
      #       .then (messageChunks) ->
      #         messages = _.flatten messageChunks
      #         resolve messages
      #
      # getParsedMessages: (messages, matchers) ->
      #   _ messages
      #     .map (message) ->
      #       matcher = _.find matchers, number: message.address
      #       (eval matcher.matchFn) message
      #     .filter()
      #     .value()
      #
      # get: ->
      #   @getMatchers()
      #     .then (matchers) =>
      #       @getMessages matchers
      #         .then (messages) =>
      #           parsedMessages = @getParsedMessages messages, matchers
      #           console.log JSON.stringify parsedMessages
  ]
