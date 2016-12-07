# frozen_string_literal: true
class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many :attachments, as: :attachable, dependent: :destroy

  validates :body, :question_id, :user_id, presence: true

  accepts_nested_attributes_for :attachments

  scope :best_answers_except, ->(answer) { where(best: true).where.not(id: answer.id) }
  scope :ordered, -> { order(best: :desc, created_at: :asc) }

  def toggle_best
    with_lock do
      question.answers.update_all(best: false)
      self.best = !best
      save
    end
  end
end
