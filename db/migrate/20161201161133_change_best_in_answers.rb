class ChangeBestInAnswers < ActiveRecord::Migration[5.0]
  def change
    change_column_null :answers, :best, false
  end
end
