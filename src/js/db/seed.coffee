seedData =
  wallets: [
    { id: 1, name: 'Наличные', type: 'cash', balance: 0 }
    { id: 2, name: 'Карта', type: 'card', balance: 0, sms_name: 'VISA2923' }
  ]
  types: [
    { id: 0, name: '<N/A>' }
    { id: 1, name: 'Кафе' }
    { id: 2, name: 'Рестораны' }
    { id: 3, name: 'Техника' }
    { id: 4, name: 'Arduino', parent_id: 3 }
    { id: 5, name: 'Одежда' }
  ]
  sms_matchers: [
    {
      number: 900
      matchFn: '(' + ((message) ->
        matches = message.body.match /^(\w+) (\d{2}\.\d{2}\.\d{2} \d{2}:\d{2}) ([^\d]+) ([\d\.]+)р (.*) Баланс: ([\d\.]+)р$/
        if matches
          [all, card, dateRaw, operationRaw, sumRaw, place, balanceRaw] = matches
          return {
            card
            date: moment(dateRaw, 'DD.MM.YYYY HH:mm:ss').unix()
            operation: { 'покупка': 'payment', 'выдача наличных': 'cashOut', 'зачисление': 'cashIn' }[operationRaw]
            sum: Math.round sumRaw * 100
            place
            balance: Math.round balanceRaw * 100
          }
        else
          null
      ).toString() + ')'
    }
  ]
  flows: [
    { sum: 25000, source_id: 1, type_id: 1, date: moment().subtract('1', 'day').startOf('day').add('14', 'hours').unix() }
    { sum: 72000, source_id: 2, type_id: 4, date: moment().subtract('1', 'day').startOf('day').add('15', 'hours').unix() }
    { sum: 1200000, source_id: 2, type_id: 5, date: moment().subtract('1', 'day').startOf('day').add('21', 'hours').unix() }
    { sum: 32000, source_id: 1, type_id: 1, date: moment().subtract('2', 'hours').unix() }
    { sum: 47000, source_id: 2, type_id: 1, date: moment().subtract('1', 'hours').unix() }
  ]

module.exports = seedData
