class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def authority_forbidden(error)
    Authority.logger.warn(error.message)
    redirect_to request.referrer.presence || root_path, :alert => '권한이 없습니다.'
  end

end
