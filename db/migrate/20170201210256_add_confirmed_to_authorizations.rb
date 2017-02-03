class AddConfirmedToAuthorizations < ActiveRecord::Migration[5.0]
  def change
    add_column :authorizations, :confirmed, :boolean, default: false
    add_index :authorizations, :confirmed
  end
end
