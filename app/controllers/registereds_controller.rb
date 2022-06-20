class RegisteredsController < ApplicationController

  before_action :check_authorized

  def index
    @preregs = EcRegistration.includes(:name_meta, :vekn_meta, :country_meta).order(:name).page params[:page]
    @prereg_count = EcRegistration.count
  end

end
