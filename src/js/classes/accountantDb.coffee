DbWithSchema = require './dbWithSchema'

class AccountantDb extends DbWithSchema
  updateWallets: ->
    console.log 'Updating wallets...'
    @execute 'UPDATE wallets SET balance = COALESCE(-(SELECT SUM(sum) FROM flows WHERE flows.source_id = wallets.id), 0)'
      .then => @notifyChanged 'wallets'

module.exports = AccountantDb
