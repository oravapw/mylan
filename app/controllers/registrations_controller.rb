class RegistrationsController < ApplicationController

  def show
    slug = params[:id]
    @tournament = Tournament.where(prereg_slug: slug).first
    if @tournament.nil?
      flash.alert = 'No such tournament, sorry.'
      return
    end

    @page_title = "Registration for \"#{@tournament.name}\""
    calculate_per_country
  end

  def search
    @tournament = Tournament.find(params[:id])
    flash.alert 'This tournament does not allow self-registration' unless @tournament.prereg_open?
  end

  def edit
    return unless init_for_token(params[:id])
    @page_title = "#{@player.name} registration for \"#{@tournament.name}\""
    calculate_per_country
  end

  def update
    return unless init_for_token(params[:id])
    changes = []

    email = params[:email]
    if email.present? && email != @player.email
      @player.email = email
      @player.save!
      if email.present? && @player.player.present? # also update to base player data, unless blank
        @player.player.email = email
        @player.player.save!
      end
      changes << "Email updated"
    end

    decklist = params[:decklist]&.strip
    if decklist.present? && decklist != @player.decklist
      @player.decklist = decklist
      @player.save!
      changes << "Decklist updated"
    end

    flash.notice = changes.join(", ") unless changes.empty?
    redirect_to edit_registration_path(params[:id])
  end

  private

  def init_for_token(token)
    @player = TournamentPlayer.where(token: token).first
    if @player.nil?
      flash.alert = 'Invalid token'
      false
    else
      @tournament = @player.tournament
      true
    end
  end

  def calculate_per_country
    @per_country = []

    if @tournament.tournament_players.present?
      # load in country info for players
      ids = @tournament.tournament_players.map { |tp| tp.player_id }
      id_to_c = {}
      Player.where(id: ids).pluck(:id, :country).each { |result| id_to_c[result[0]] = result[1] }
      @tournament.tournament_players.each { |tp| tp.country = id_to_c[tp.player_id] }

      # calculate per-country totals into array of arrays, in descending count order
      @per_country = @tournament.tournament_players.map { |tp| tp.country_name }
                                .tally.sort_by { |_key, value| value }.reverse
    end
  end
end
