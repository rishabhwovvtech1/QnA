# First point of contact for every non API request to the application

class ApplicationController < ActionController::Base
    include ExceptionHelper
    include PermissionsHelper
    include ApplicationControllerHelper
    #include DeviceControllerHelper
  
    helper_method :current_user
  
    # Devise user authentication
  
    # def set_current_user
    #   @_current_user ||= current_user
    # end
  
    protected
    def authenticate_user
      if session[:user_id]
        # set current user object to @current_user object variable
        @current_user = User.find session[:user_id]
        return true
      else
        redirect_to(:controller => 'sessions', :action => 'login')
        return false
      end
    end
  
    def save_login_state
      if session[:user_id]
        redirect_to(:controller => 'users', :action => 'dashboard')
        return false
      else
        return true
      end
    end
  
    private
      # Renders the error page for exceptions raised in the controllers inherited from Admin::AdminController
      # also send email to devs about the exception
      #
      # Author:: Raj
      # Date:: 2/06/2016
      # Reviewed By:: Raj
      #
      def set_resource
        resource_class_name = controller_name.classify
        resource = "@#{ resource_class_name.underscore }"
        instance_variable_set(resource, resource_class_name.constantize.find(params[:id]))
      end
  
  
  end
  