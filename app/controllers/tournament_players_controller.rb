class TournamentPlayersController < ApplicationController

  def new
  end

  def create
    @player = TournamentPlayer.new(tournament_player_params)
    @tournament = Tournament.find(params[:tournament_id])
    @player.tournament = @tournament
    unless @player.save
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @player = TournamentPlayer.find(params[:id])
    @tournament = @player.tournament
    @player.destroy
  end

  def toggle_decklist
    @player = TournamentPlayer.find(params[:id])
    @player.decklist = !@player.decklist
    @player.save!
    render partial: "tournaments/playerlist", locals: { tournament: @player.tournament }
  end

  private

  def tournament_player_params
    params.require(:tournament_player).permit(:name, :vekn, :prereg, :player_id, :decklist)
  end

end
