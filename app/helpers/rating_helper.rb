# frozen_string_literal: true
module RatingHelper
  def liked?(voteable)
    return false unless current_user
    vote = voteable.votes.find_by(user_id: current_user.id)
    vote&.value == 1
  end

  def disliked?(voteable)
    return false unless current_user
    vote = voteable.votes.find_by(user_id: current_user.id)
    vote&.value == -1
  end
end
