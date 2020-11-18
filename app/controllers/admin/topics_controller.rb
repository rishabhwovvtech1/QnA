class Admin::TopicsController < ApiController
    before_action :authenticate_user
    def index
        @topics = Topic.all
        @following = UserFollow.where(user_id: @current_user.id).pluck(:topic_id)
    end

    def follow
        @follow = UserFollow.new(user_id: @current_user.id, topic_id: params[:topic_id])
        if @follow.save
          set_flash_notification :success, :follow, entity: 'Topic'
        else
          set_instant_flash_notification :danger, :default, {:message => @follow.errors.messages[:base][0]}
        end
        redirect_to admin_topics_path
      end

      def error 
        set_flash_notification :danger, :already, entity: 'Topic'
        redirect_to admin_topics_path
      end
end