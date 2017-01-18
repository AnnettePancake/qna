# frozen_string_literal: true
module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :voteable, dependent: :destroy
  end

  def toggle_rating(user, value)
    with_lock do
      vote = votes.find_by(user_id: user.id)

      if vote
        vote.destroy
      else
        votes.create(user_id: user.id, value: value)
      end
    end
  end

  def rating
    votes.sum(:value)
  end
end
