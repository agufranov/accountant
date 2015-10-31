DbWithSchema = require './dbWithSchema'

class AccountantDb extends DbWithSchema
  updateWallets: ->
    @execute 'UPDATE wallets SET balance = COALESCE(-(SELECT SUM(sum) FROM flows WHERE flows.source_id = wallets.id), 0)'

module.exports = AccountantDb
