# frozen_string_literal: true
class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true
end
