seedData =
  wallets: [
    { name: 'Наличные', type: 'cash', balance: 0, icon: 'ion-cash assertive' }
    { name: 'Карта', type: 'card', balance: 0, sms_name: 'VISA2923', icon: 'ion-card balanced' }
  ]
  types: [
    { id: 10, name: 'Питание', icon: 'ion-fork' }
      { id: 101, name: 'Кафе', icon: 'ion-pizza', parent_id: 10 }
      { id: 102, name: 'Продукты', icon: 'ion-android-cart', parent_id: 10 }
    { id: 20, name: 'Хозяйство', icon: '' }
    { id: 30, name: 'Транспорт', icon: 'ion-android-bus' }
    { id: 40, name: 'Связь', icon: '' }
      { id: 401, name: 'Мобильная связь', icon: 'ion-android-call', parent_id: 40 }
      { id: 402, name: 'Интернет', icon: 'ion-wifi', parent_id: 40 }
    { id: 50, name: 'Проживание', icon: 'ion-home' }
    { id: 60, name: 'Кредиты', icon: '' }
    { id: 70, name: 'Электроника', icon: 'ion-calculator' }
      { id: 701, name: 'Компьютер', parent_id: 70, icon: 'ion-laptop' }
      { id: 702, name: 'Arduino', parent_id: 70, icon: 'ion-calculator' }
    { id: 80, name: 'Бытовая техника', icon: 'ion-calculator' }
    { id: 90, name: 'Одежда', icon: 'ion-tshirt' }
    { id: 100, name: 'Развлечения', icon: 'ion-coffee' }
      { id: 1001, name: 'Рестораны', icon: 'ion-wineglass', parent_id: 100 }
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
    # { sum: 25000, source_id: 1, type_id: 1, date: moment().subtract('1', 'day').startOf('day').add('14', 'hours').unix() }
    # { sum: 72000, source_id: 2, type_id: 4, date: moment().subtract('1', 'day').startOf('day').add('15', 'hours').unix() }
    # { sum: 1200000, source_id: 2, type_id: 5, date: moment().subtract('1', 'day').startOf('day').add('21', 'hours').unix() }
    # { sum: 32000, source_id: 1, type_id: 1, date: moment().subtract('2', 'hours').unix() }
    # { sum: 47000, source_id: 2, type_id: 1, date: moment().subtract('1', 'hours').unix() }
  ]
  places: [
    { number_id: 1, name: 'AUCHAN GULLIVER SPB', type_id: 102 }
  ]

module.exports = seedData
