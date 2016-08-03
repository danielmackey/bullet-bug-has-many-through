class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  around_action :skip_bullet, if: :skip_bullet?

  protected

    def skip_bullet
      Bullet.enable = false
      yield
    ensure
      Bullet.enable = true
    end

    def skip_bullet?
      params[:skip_bullet].present?
    end

end
