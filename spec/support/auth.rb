module Auth
  def create_user!
    @user = User.create(email: 'foo@bar.com', password: '11111111')
  end

  def sign_in_user!
    create_user! unless @user
    setup_devise_mapping!
    sign_in @user
  end

  def sign_out_user!
    setup_devise_mapping!
    sign_out @user
  end

  def setup_devise_mapping!
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  def login_with_warden!
    create_user! unless @user
    login_as(@user, scope: :user)
  end

  def logout_with_warden!
    logout(:user)
  end

  def login_and_logout_with_devise
    sign_in_user!
    yield
    sign_out_user!
  end

  def login_and_logout_with_warden
    Warden.test_mode!
    login_with_warden!
    yield
    logout_with_warden!
    Warden.test_reset!
  end
end
