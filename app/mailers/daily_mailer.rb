# frozen_string_literal: true
class DailyMailer < ApplicationMailer
  def digest(user)
    @questions = Question.past_day
    mail(to: user.email, subject: 'Daily digest of questions')
  end
end
