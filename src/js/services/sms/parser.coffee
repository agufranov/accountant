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
        Db.ready ->
          Db.snapshot ['wallets', 'sms_matchers', 'places']
        .then (snapshot) ->
          messageToFlow = (matcher) ->
            (msg) ->
              walletId = undefined
              type_id = if (matchingPlace = _.find snapshot.places, number_id: matcher.id, name: msg.place)
                matchingPlace.type_id
              else
                0
              if matchingWallet = _.find(snapshot.wallets, sms_name: msg.card)
                walletId = matchingWallet.id
              sum: if msg.operation is 'cashIn' then -msg.sum else msg.sum
              source_id: walletId
              type_id: type_id
              date: msg.date
              sms_matcher_id: matcher.id
              sms_card_name: msg.card
              sms_place_name: msg.place
              sms_balance: msg.balance

          qs = []
          for matcher in snapshot.sms_matchers
            qs.push(new MessageProvider matcher
              .getMessages()
              .then do (matcher) ->
                (messages) ->
                  maxMessageId = _.max(messages, '_id')._id
                  parsedMessages = _ messages
                    .map eval matcher.matchFn
                    .filter()
                    .value()
                  console.log JSON.stringify message for message in parsedMessages
                  flows = parsedMessages.map messageToFlow(matcher)
                  Db.transaction (tx) ->
                    Db.flows.insertMultiple flows, {}, tx
                    Db.sms_matchers.update { readFrom: maxMessageId + 1 }, { id: matcher.id }, tx
                  .then ->
                    # TODO separate from here
                    Db.flows.select columns: ['SUM(sum) as total']
                  .then (rows) ->
                    console.log rows[0].total
                    Db.wallets.update { balance: -rows[0].total }, { where: { id: 1 } }
            )
          $q.all qs
  ]
