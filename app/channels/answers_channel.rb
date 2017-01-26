class AnswersChannel < ApplicationCable::Channel
  def follow_answer
    stream_from "answer_question_#{params[:question_id]}"
  end
end
