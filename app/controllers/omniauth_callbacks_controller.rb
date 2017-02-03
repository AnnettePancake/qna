# frozen_string_literal: true
class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    auth_sign_in('Facebook')
  end

  def twitter
    authorization = Authorization.find_by(provider: 'twitter', uid: request_auth['uid'])

    if authorization
      if authorization.confirmed?
        success_redirect(authorization.user, 'Twitter')
      else
        redirect_to root_path, flash: { alert: 'You need to confirm email' }
      end
    else
      @auth = request_auth
      render 'devise/registrations/email_request'
    end
  end

  def send_email_confirmation
    authorization = Authorization.create!(
      provider: params[:provider],
      uid: params[:uid],
      temporary_email: params[:email],
      confirmation_token: SecureRandom.hex(30),
      confirmed: false
    )

    UserMailer.email_confirmation(authorization).deliver
    redirect_to root_path, flash: { notice: 'Check your email' }
  end

  def email_confirmation
    authorization = Authorization.find_by(confirmation_token: params[:token], confirmed: false)

    unless authorization
      redirect_to(root_path, flash: { error: 'Sorry, invalid confirmation' }) && return
    end

    email = authorization.temporary_email
    user = User.find_by(email: email) || User.generate_user(email)

    authorization.update_attributes(confirmed: true, user_id: user.id)
    success_redirect(user, 'Twitter')
  end

  private

  def auth_sign_in(provider)
    @user = User.find_for_oauth(request_auth)

    return unless @user.persisted?

    success_redirect(@user, provider)
  end

  def request_auth
    request.env['omniauth.auth']
  end

  def success_redirect(user, provider)
    sign_in_and_redirect user, event: :authentication
    set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
  end
end
