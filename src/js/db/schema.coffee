schema =
  flows:
    primaryKey: 'id'
    columns:
      id: type: 'INTEGER'
      sum: type: 'INTEGER', null: false, check: "TYPEOF(sum) = 'integer'"
      type_id: type: 'reference', table: 'types'
      date: type: 'INTEGER', null: false, default: "(strftime('%s', 'now'))"
      comment: type: 'INTEGER', null: false, default: "''"
      source_id: type: 'reference', table: 'wallets'
      dest_id: type: 'reference', table: 'wallets'
      sms_card_name: type: 'TEXT'
      sms_place_name: type: 'TEXT'
      sms_balance: type: 'INTEGER'
  wallets:
    primaryKey: 'id'
    columns:
      id: type: 'INTEGER'
      name: type: 'TEXT', null: false
      type: type: 'TEXT', null: false
      balance: type: 'INTEGER', null: false
      sms_name: type: 'TEXT'
      icon: type: 'TEXT'
  types:
    primaryKey: 'id'
    columns:
      id: type: 'INTEGER'
      name: type: 'TEXT', null: false
      parent_id: type: 'reference', table: 'types'
      icon: type: 'TEXT'
  sms_matchers:
    primaryKey: 'id'
    columns:
      id: type: 'INTEGER'
      number: type: 'TEXT', null: false
      matchFn: type: 'TEXT', null: false
      readFrom: type: 'INTEGER', null: false, default: '0'
  test:
    primaryKey: 'id'
    columns:
      id: type: 'INTEGER'
      data: type: 'TEXT'

module.exports = schema
