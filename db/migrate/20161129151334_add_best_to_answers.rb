class AddBestToAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :best, :boolean, default: false
    add_index :answers, :best
  end
end
