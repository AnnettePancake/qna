# frozen_string_literal: true
class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  after_save ThinkingSphinx::RealTime.callback_for(:comment)

  validates :body, presence: true

  def question
    return commentable if commentable.is_a?(Question)
    commentable.question
  end
end
