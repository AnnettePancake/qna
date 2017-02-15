# frozen_string_literal: true
class ApplicationMailer < ActionMailer::Base
  default from: 'support@qna.local'
  layout 'mailer'
end
