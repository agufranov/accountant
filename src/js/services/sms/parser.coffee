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

      go: ->
        snapshot = {}
        Db.ready ->
          $q.all [
            Db.sms_matchers.select().then (matchers) -> snapshot.matchers = matchers
            Db.wallets.select().then (wallets) -> snapshot.wallets = wallets
          ]
        .then ->
          messageToFlow = (msg) ->
            walletId = undefined
            if matchingWallet = _.find(snapshot.wallets, sms_name: msg.card)
              walletId = matchingWallet.id
            sum: if msg.operation is 'cashIn' then -msg.sum else msg.sum
            source_id: walletId
            date: msg.date
            sms_card_name: msg.card
            sms_place_name: msg.place
            sms_balance: msg.balance

          qs = []
          for matcher in snapshot.matchers
            qs.push(new MessageProvider matcher
              .getMessages()
              .then do (matcher) ->
                (messages) ->
                  maxMessageId = _.max(messages, '_id')._id
                  console.log maxMessageId
                  parsedMessages = _ messages
                    .map eval matcher.matchFn
                    .filter()
                    .value()
                  console.log JSON.stringify message for message in parsedMessages
                  flows = parsedMessages.map messageToFlow
                  Db.transaction (tx) ->
                    Db.flows.insertMultiple flows, {}, tx
                    Db.sms_matchers.update { readFrom: maxMessageId + 1 }, { id: matcher.id }, tx
            )
          $q.all qs
  ]
