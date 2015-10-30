seedData =
  wallets: [
    { name: 'Наличные', type: 'cash', balance: 0, icon: 'ion-cash assertive' }
    { name: 'Карта', type: 'card', balance: 0, sms_name: 'VISA2923', icon: 'ion-card balanced' }
  ]
  types: [
    { id: 0, name: '<N/A>', icon: 'ion-help' }
    { id: 1, name: 'Кафе', icon: 'ion-fork' }
    { id: 2, name: 'Рестораны', icon: 'ion-coffee' }
    { id: 3, name: 'Техника', icon: 'ion-calculator' }
    { id: 4, name: 'Arduino', parent_id: 3 }
    { id: 5, name: 'Одежда', icon: 'ion-tshirt' }
    { id: 6, name: 'Продукты', icon: 'ion-bag' }
  ]
  sms_matchers: [
    {
      id: 1
      number: 900
      matchFn: '(' + ((message) ->
        matches = message.body.match /^(\w+) (\d{2}\.\d{2}\.\d{2} \d{2}:\d{2}) ([^\d]+) ([\d\.]+)р (.*) Баланс: ([\d\.]+)р$/
        if matches
          [all, card, dateRaw, operationRaw, sumRaw, place, balanceRaw] = matches
          return {
            card
            date: moment.utc(dateRaw, 'DD.MM.YYYY HH:mm:ss').unix()
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
  places: [
    { number_id: 1, name: 'AUCHAN GULLIVER SPB', type_id: 6 }
  ]

module.exports = seedData
