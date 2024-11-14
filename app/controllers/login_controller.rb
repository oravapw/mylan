class LoginController < ApplicationController
  def index; end

  def authenticate
    # this is *really* simple, but all we need for now
    want_username = ENV.fetch("LOGIN_USERNAME")
    want_password = ENV.fetch("LOGIN_PASSWORD")
    if params[:username] == want_username && params[:password] == want_password
      session[:user_name] = want_username
      redirect_to root_path
    else
      redirect_to login_path, alert: "Username and/or password not valid"
    end
  end

  def logout
    session[:user_name] = nil
    redirect_to login_path
  end
end
