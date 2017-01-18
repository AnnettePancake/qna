class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.integer :voteable_id
      t.string :voteable_type
      t.timestamps
    end

    add_index :votes, [:voteable_id, :voteable_type]
  end
end
