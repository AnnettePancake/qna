# frozen_string_literal: true
class UserMailer < ApplicationMailer
  default from: 'support@qna.local'

  def email_confirmation(authorization)
    @email = authorization.temporary_email
    @token = authorization.confirmation_token

    mail(to: @email, subject: 'Email confirmation for your qna account')
  end
end
