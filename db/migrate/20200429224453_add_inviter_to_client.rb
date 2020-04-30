class AddInviterToClient < ActiveRecord::Migration[5.2]
  def change
    add_reference :clients, :inviter, index: true
  end
end
