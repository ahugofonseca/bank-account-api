class ChangeBithDateTypeToClient < ActiveRecord::Migration[5.2]
  def change
    change_column :clients, :birth_date, :string
  end
end
