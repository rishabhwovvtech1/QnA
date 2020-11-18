class Admin::UsersController < ApiController
  before_action :authenticate_user

  def index
    @questions = @current_user.questions
  end

  def new
    @user = User.new
  end

  def dashboard
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @follows = false
    id = @user.id
    @same = false
    if id == @current_user.id
      @same = true
    end
    ids = UserFollow.where(user_id: @current_user.id).pluck(:followed_user_id)
    if ids.include?(id)
      @follows = true
    end
    @questions = @user.questions
  end

  def create
    @user = User.new(user_params)
    if @user.save
      set_flash_notification :success, :create, entity: 'User'
      redirect_to admin_users_path
    else
      set_instant_flash_notification :danger, :default, {:message => @user.errors.messages[:base][0]}
      render :new
    end
  end

  def follow
    @follow = UserFollow.new(user_id: @current_user.id, followed_user_id: params[:follow_id])
    if @follow.save
      set_flash_notification :success, :follow, entity: 'User'
    else
      set_instant_flash_notification :danger, :default, {:message => @follow.errors.messages[:base][0]}
    end
    redirect_to admin_questions_path
  end

  def edit
    @user = User.find(params[:id])
  end


  def update
    @user = User.find(params[:id])
    @user.attributes = user_params
    if @user.important_changed?
    end
    if @user.save
      set_flash_notification :success, :update, entity: 'User'
      redirect_to admin_users_path
    else
      set_instant_flash_notification :danger, :default, {:message => @user.errors.messages[:base][0]}
      render :edit
    end
  end

  def error 
    set_flash_notification :danger, :already, entity: 'User'
    redirect_to admin_questions_path
  end

  private
  def user_params
    params.require(:user).permit(:name, :username, :phone_number, :password)
  end


  def checks_for_logged_in_user
    unless user_signed_in?
      protocol = Rails.application.routes.default_url_options[:protocol] || "http"
      redirect_to new_user_session_url(protocol: protocol)
    end
  end
end
