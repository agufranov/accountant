schema =
  flows:
    primaryKey: 'id'
    columns:
      id: type: 'INTEGER'
      sum: type: 'INTEGER', null: false, check: "TYPEOF(sum) = 'integer' AND sum > 0"
      type_id: type: 'reference', table: 'types', null: false
      date: type: 'INTEGER', null: false, default: "(strftime('%s', 'now'))"
      comment: type: 'INTEGER', null: false, default: "''"
      source_id: type: 'reference', table: 'wallets', null: false
      dest_id: type: 'reference', table: 'wallets'
  wallets:
    primaryKey: 'id'
    columns:
      id: type: 'INTEGER'
      name: type: 'TEXT', null: false
      type: type: 'TEXT', null: false
      balance: type: 'INTEGER', null: false
  types:
    primaryKey: 'id'
    columns:
      id: type: 'INTEGER'
      name: type: 'TEXT', null: false
      parent_id: type: 'reference', table: 'types'
  sms_matchers:
    primaryKey: 'id'
    columns:
      id: type: 'INTEGER'
      number: type: 'TEXT', null: false
      matchFn: type: 'TEXT', null: false
      readFrom: type: 'INTEGER', null: false, default: '0'

module.exports = schema
