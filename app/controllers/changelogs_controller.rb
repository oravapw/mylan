class ChangelogsController < ApplicationController
  before_action :check_authorized

  def index
    @logs = Changelog.order(id: :desc).page params[:page]
    if turbo_frame_request?
      render partial: "changelogs", locals: { logs: @logs }
    end
  end

end
