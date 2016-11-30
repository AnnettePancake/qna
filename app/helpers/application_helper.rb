# frozen_string_literal: true
module ApplicationHelper
  def shallow_args(question, answer)
    answer.new_record? ? [question, answer] : answer
  end
end
