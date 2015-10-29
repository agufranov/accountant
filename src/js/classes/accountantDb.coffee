DbWithSchema = require './dbWithSchema'

class AccountantDb extends DbWithSchema
  updateWallets: ->
    @execute 'UPDATE wallets SET balance = -(SELECT SUM(sum) FROM flows WHERE flows.source_id = wallets.id)'

module.exports = AccountantDb
