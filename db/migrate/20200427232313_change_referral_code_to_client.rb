class ChangeReferralCodeToClient < ActiveRecord::Migration[5.2]
  def change
    remove_column :clients, :referral_code
    add_column :clients, :referral_code, :string

    add_index :clients, :referral_code, unique: true
  end
end
