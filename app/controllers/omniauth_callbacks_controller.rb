class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    auth_sign_in('Facebook')
  end

  def twitter
    authorization = Authorization.find_by(provider: 'twitter', uid: request.env['omniauth.auth']['uid'])

    if authorization
      if authorization.confirmed?
        sign_in_and_redirect authorization.user, event: :authentication
        set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
      else
        redirect_to root_path, flash: { alert: "You need to confirm email" }
      end
    else
      @auth = request.env['omniauth.auth']
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
      redirect_to root_path, flash: { error: 'Sorry, invalid confirmation' } and return
    end

    user = User.find_by(email: authorization.temporary_email)

    if user
      authorization.update_attributes(confirmed: true, user_id: user.id)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(
        email: authorization.temporary_email,
        password: password,
        password_confirmation: password
      )
      authorization.update_attributes(confirmed: true, user_id: user.id)
    end

    set_flash_message(:notice, :success, kind: 'Twitter')
    sign_in_and_redirect user, event: :authentication
  end

  private

  def auth_sign_in(provider)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    end
  end
end
