# frozen_string_literal: true
class Subscription < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :question, optional: true

  validates :user_id, :question_id, presence: true
  validates :user_id, uniqueness: { scope: :question_id }
end
