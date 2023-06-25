class RegistrationsController < ApplicationController

  def show
    slug = params[:id]
    @tournament = Tournament.where(prereg_slug: slug).first
    if @tournament.nil?
      flash.alert = 'No such tournament, sorry.'
      return
    end
  end

end
