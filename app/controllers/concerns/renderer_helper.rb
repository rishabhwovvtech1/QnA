module RendererHelper

  def response_success(payload, message = "", meta_data = {}, next_action = {})
    base_response(payload, meta_data, message, "001", :SUCCESS, next_action)
  end

  def render_success(payload, message = "", meta_data = {}, next_action = {})
    render(json: base_response(payload, meta_data, message, "001", :SUCCESS, next_action), status: :ok)
  end

  def render_error(payload, message = "", meta_data = {}, next_action = {})
    render(json: base_response(payload, meta_data, message, "002", :ERROR, next_action), status: :ok)
  end

  def render_resource_not_found(meta_data = {})
    render(json: base_response({}, meta_data, "No Record Found", "003", :NOT_FOUND, {}), status: :not_found)
  end

  def render_collection(payload, serializer, meta_data = {})
    render(json: base_response(ActiveModel::ArraySerializer.new(payload, each_serializer: serializer), meta_data, "success", "001", :SUCCESS, {}), status: :ok)
  end

  def render_unprocessable(payload, meta_data = {})
    render(json: { payload: payload, meta: meta_data, nextAction: {} }, status: 422)
  end

  def render_unauthorized(entity, meta_data = {})
    render(json: { payload: t('api.errors.unauthorized', entity: entity), meta: meta_data, nextAction: {} }, status: :unauthorized)
  end


  def render_not_modified
    render(json: nil, status: :not_modified)
  end

  def render_resource_not_modified(resource, action, meta_data = {})
    render(json: {
        payload: t("api.errors.#{ action }", entity: resource.class),
        errors: resource.errors.full_messages,
        meta: meta_data
    }, status: 422)
  end

  def render_resource_not_destroyed(resource, meta_data = {})
    render(json: {
        payload: t('api.errors.destroy_failed', entity: resource.class),
        meta: meta_data
    }, status: 422)
  end

  # def render_unpermitted_params(meta_data = {})
  #   render(json: { meta: meta_data }, status: :unprocessable_entity)
  # end

  private
  def base_response(payload, meta_data, message, code, status, nextAction)
    {
        payload: payload,
        meta: meta_data,
        status: {
            message: message,
            code: code,
            status: status
        },
        nextAction: nextAction
    }
  end
end
