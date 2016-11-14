class RemoveTitleFromAnswers < ActiveRecord::Migration[5.0]
  def change
    remove_column :answers, :title
  end
end
