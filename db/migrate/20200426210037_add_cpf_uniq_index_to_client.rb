class AddCpfUniqIndexToClient < ActiveRecord::Migration[5.2]
  def change
    add_index :clients, :cpf, unique: true
  end
end
