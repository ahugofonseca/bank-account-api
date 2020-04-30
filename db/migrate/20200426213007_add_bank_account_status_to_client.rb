class AddBankAccountStatusToClient < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :bank_account_status, :integer, default: 0
  end
end
