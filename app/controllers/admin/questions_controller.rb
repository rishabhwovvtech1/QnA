class Admin::QuestionsController < ApiController
  before_action :authenticate_user

  def index
    user = @current_user.id
    following = UserFollow.where(user_id: user).pluck(:followed_user_id)
    topic_ids = UserFollow.where(user_id: user).pluck(:topic_id)
    @questions =  Question.where(user_id: following).or(Question.where(topic_id: topic_ids))
  end

  def show
    @question = Question.find(params[:id])
    @answer = Answer.new
  end
  def new
    @question = Question.new
  end
  
  def create
    @question = Question.new(question_params)
    @question.user_id = @current_user.id
    if @question.save
      set_flash_notification :success, :create, entity: 'Question'
      redirect_to admin_users_path
    else
      set_instant_flash_notification :danger, :default, {:message => @question.errors.messages[:base][0]}
      render :new
    end
  end

  private
  def question_params
    params.require(:question).permit(:description, :topic_id)
  end


  def checks_for_logged_in_user
    unless user_signed_in?
      protocol = Rails.application.routes.default_url_options[:protocol] || "http"
      redirect_to new_user_session_url(protocol: protocol)
    end
  end
end
