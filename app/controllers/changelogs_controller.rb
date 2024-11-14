class ChangelogsController < ApplicationController
  before_action :check_authorized

  def index
    @logs = Changelog.includes(:player, :tournament).order(id: :desc).page params[:page]
    return unless turbo_frame_request?

    render partial: "changelogs", locals: { logs: @logs }
  end
end
