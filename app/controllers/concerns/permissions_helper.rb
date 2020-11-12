module PermissionsHelper
  private
    def check_permissions(permission)
      method_name = "can_#{ permission.underscore }?"

      unless current_user.public_send(method_name)
        set_flash_notification :error, :unauthorized
        redirect_to after_sign_in_path_for(current_user)
      end
    end
end
