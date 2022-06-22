class ChangelogsController < ApplicationController

  def index
    @logs = Changelog.order(created_at: :desc).page params[:page]
  end

end
