module ControllerMacros
  def sign_in_user(name = nil)
    before do
      @user = name ? public_send(name) : create(:user)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in @user
    end
  end
end
