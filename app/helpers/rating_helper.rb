module RatingHelper
  def liked?(voteable)
    vote = voteable.votes.find_by(user_id: current_user.id)
    vote&.value == 1
  end

  def disliked?(voteable)
    vote = voteable.votes.find_by(user_id: current_user.id)
    vote&.value == -1
  end
end
