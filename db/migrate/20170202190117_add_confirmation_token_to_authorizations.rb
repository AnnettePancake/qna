class AddConfirmationTokenToAuthorizations < ActiveRecord::Migration[5.0]
  def change
    add_column :authorizations, :confirmation_token, :string
    add_index :authorizations, :confirmation_token
  end
end
