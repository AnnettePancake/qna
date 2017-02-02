class AddTemporaryEmailToAuthorizations < ActiveRecord::Migration[5.0]
  def change
    add_column :authorizations, :temporary_email, :string
  end
end
