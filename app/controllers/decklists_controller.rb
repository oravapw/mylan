class DecklistsController < ApplicationController
  before_action :check_authorized
  def index
    @tournaments = Tournament.joins(:tournament_players)
                             .includes(:tournament_players)
                             .merge(TournamentPlayer.with_decklist)
                             .order("date desc", :name)
                             .distinct
    @tournament_players = TournamentPlayer.group(:tournament_id).count
  end

  def tournament_index
    @tournament = Tournament.find(params[:id])
    if @tournament.present?
      @players = @tournament.tournament_players.with_decklist.order(:name).all
    else
      flash[:alert] = "No such tournament"
      redirect_to decklists_path
    end
  end

  def show
    @player = TournamentPlayer.find(params[:id])
  end
end
