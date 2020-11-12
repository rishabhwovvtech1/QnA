class ApiController < ApplicationController

  # Resque all exceptions a Base Controller Level
  include ExceptionHelper
  include RendererHelper

  skip_before_action :verify_authenticity_token

  #include AuthenticateHelper

end
