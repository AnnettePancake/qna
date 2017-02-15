# frozen_string_literal: true
class QuestionMailer < ApplicationMailer
  def question_subscription(user, answer)
    @answer = answer
    mail(to: user.email, subject: 'New answer for subscribed question')
  end
end
