class QuestionsChannel < ApplicationCable::Channel
  def follow_question
    stream_from 'questions'
  end
end
