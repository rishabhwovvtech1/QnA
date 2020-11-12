module ApplicationControllerHelper
  private
    def set_flash_notification(type, kind, options = {})
      message = options[:message] || t("flash.#{ type }.#{ kind }", options)
      flash[type] = message if message.present?
    end

    def set_instant_flash_notification(type, kind, options = {})
      message = options[:message] || t("flash.#{ type }.#{ kind }", options)
      flash.now[type] = message if message.present?
    end

    def only_allow_xhr_request
      (render(text: 'Not Allowed', status: :bad_request) and return) unless request.xhr?
    end

    def only_allow_super_admin
      unless @current_user.super_admin?
        if request.xhr?
          render(text: t('flash.error.unauthorized'), status: 401) and return
        else
          set_flash_notification :error, :unauthorized
          redirect_to after_sign_in_path_for(current_user)
        end
      end
    end

    def redirect_to_back_or_default(_params={})
      redirection_path = request.referrer || after_sign_in_path_for(current_user)
      uri = URI(redirection_path)
      uri.query = _params.to_query
      redirect_to uri.to_s
    end

    def set_flash_errors(resource, type = :error)
      flash[type] = resource.errors.full_messages.join("<br>")
    end
end
