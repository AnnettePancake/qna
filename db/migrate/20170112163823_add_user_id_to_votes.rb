class AddUserIdToVotes < ActiveRecord::Migration[5.0]
  def change
    add_column :votes, :user_id, :integer
    add_index :votes, :user_id
  end
end
