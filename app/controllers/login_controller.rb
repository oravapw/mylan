class LoginController < ApplicationController

  def index
  end

  def authenticate
    # this is *really* simple, but all we need for now
    want_username = Rails.application.credentials.dig(:login, Rails.env.to_sym, :username)
    want_password = Rails.application.credentials.dig(:login, Rails.env.to_sym, :password)
    if params[:username] == want_username &&  params[:password] == want_password
      session[:logged_in] = true
      redirect_to root_path
    else
      redirect_to login_path, alert: "Username and/or password not valid"
    end
  end

  def logout
    session[:logged_in] = false
    redirect_to login_path
  end

end
