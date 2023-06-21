class ApplicationController < ActionController::Base

  def check_authorized
    redirect_to login_path unless helpers.logged_in?
  end

end
