class AddBankAccountFieldsToClient < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :name, :string
    add_column :clients, :email, :string
    add_column :clients, :birth_date, :date
    add_column :clients, :gender, :integer
    add_column :clients, :city, :string
    add_column :clients, :state, :string
    add_column :clients, :country, :string
    add_column :clients, :referral_code, :integer

    add_index :clients, :email, unique: true
    add_index :clients, :referral_code, unique: true
  end
end
