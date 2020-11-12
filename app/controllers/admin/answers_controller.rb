class Admin::AnswersController < ApiController
    before_action :authenticate_user

    def create
        @answer = Answer.new(answer_params)
        @answer.user_id = @current_user.id
        if @answer.save
        set_flash_notification :success, :create, entity: 'Answer'
        redirect_to admin_users_path
        else
        set_instant_flash_notification :danger, :default, {:message => @answer.errors.messages[:base][0]}
        render :new
        end
    end
    private
    def answer_params
        params.require(:answer).permit(:description, :question_id)
    end
end

  