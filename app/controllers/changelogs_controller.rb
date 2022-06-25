class ChangelogsController < ApplicationController

  def index
    @logs = Changelog.order(created_at: :desc).page params[:page]
    if turbo_frame_request?
      render partial: "changelogs", locals: { logs: @logs }
    else
      render :index
    end
  end

end
