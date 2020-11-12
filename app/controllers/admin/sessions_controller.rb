class Admin::SessionsController < ApiController
  before_action :authenticate_user, :only => [:logout]
  before_action :save_login_state, :only => [:login, :login_attempt]


  def login
    #Login Form
  end

  def logout
    session[:user_id] = nil
    session[:eng_id] = nil
    redirect_to(:controller => 'sessions', :action => 'login')
  end

  def login_attempt
    authorized_user = User.authenticate(params[:name],params[:login_password], "admin_user")
    if authorized_user
      session[:user_id] = authorized_user.id
      redirect_to(action: 'dashboard', controller: :users)
    else
      set_flash_notification :danger, :invalid
      render "login"
    end
  end
end
