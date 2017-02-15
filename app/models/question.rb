# frozen_string_literal: true
class Question < ApplicationRecord
  include Voteable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  belongs_to :user

  validates :title, :body, :user_id, presence: true

  accepts_nested_attributes_for :attachments, allow_destroy: true

  scope :past_day, -> { where(created_at: 24.hours.ago..Time.zone.now) }

  after_create :subscribe_author

  private

  def subscribe_author
    subscriptions.create(user_id: user.id)
  end
end
