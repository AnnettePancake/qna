# frozen_string_literal: true
class CommentsChannel < ApplicationCable::Channel
  def follow_comment
    stream_from "comments-question-#{params[:question_id]}"
  end
end
