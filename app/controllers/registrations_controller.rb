class RegistrationsController < ApplicationController

  def show
    slug = params[:id]
    @tournament = Tournament.where(prereg_slug: slug).first
    if @tournament.nil?
      flash.alert = 'No such tournament, sorry.'
      return
    end

    # load in country info for players
    if @tournament.tournament_players.present?
      ids = @tournament.tournament_players.map { |tp| tp.player_id }
      id_to_c = {}
      Player.where(id: ids).pluck(:id, :country).each { |result| id_to_c[result[0]] = result[1] }
      @tournament.tournament_players.each { |tp| tp.country = id_to_c[tp.player_id] }
    end
  end

  def search
    @tournament = Tournament.find(params[:id])
    flash.alert 'This tournament does not allow self-registration' unless @tournament.prereg_open?
  end

end
