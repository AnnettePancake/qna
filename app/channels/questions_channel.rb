# frozen_string_literal: true
class QuestionsChannel < ApplicationCable::Channel
  def follow_question
    stream_from 'questions'
  end
end
