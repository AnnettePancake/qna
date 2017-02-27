# frozen_string_literal: true
class Answer < ApplicationRecord
  include Voteable
  include Commentable

  belongs_to :question, touch: true
  belongs_to :user

  has_many :attachments, as: :attachable, dependent: :destroy

  after_save ThinkingSphinx::RealTime.callback_for(:answer)

  validates :body, :question_id, :user_id, presence: true

  accepts_nested_attributes_for :attachments, allow_destroy: true

  scope :best_answers_except, ->(answer) { where(best: true).where.not(id: answer.id) }
  scope :ordered, -> { order(best: :desc, created_at: :asc) }

  after_commit :send_subscription, on: :create

  def toggle_best
    with_lock do
      question.answers.update_all(best: false)
      self.best = !best
      save
    end
  end

  private

  def send_subscription
    QuestionSubscriptionJob.perform_later(question, self)
  end
end
