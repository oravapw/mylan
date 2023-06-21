class TournamentPlayersController < ApplicationController

  before_action :load_player, only: [:destroy, :toggle_decklist]
  before_action :load_tournament, only: [:new, :create]

  def new
    @player = TournamentPlayer.new
  end

  # this is a bit weird, since we handle multiple scenarios here and the result processing is with turbo streams
  def create
    @cancel = params[:cancel]
    unless @cancel
      # base functionality has us just creating  tournament-specific player and linking it in
      @player = TournamentPlayer.new(tournament_player_params)
      @player.tournament = @tournament

      # optionally create an "actual" player object (this is when user selects "Add new" option on search)
      if params[:create_player] == "true"
        @baseplayer = Player.new
        @baseplayer.name = @player.name
        @baseplayer.vekn = @player.vekn
        @baseplayer.country = @player.country
        if @baseplayer.save
          @player.player_id = @baseplayer.id
          Changelog.create(change_type: :add, row_id: @baseplayer.id,
                           oldvalues: nil, newvalues: @baseplayer.changelog_text)
        else
          # do not show validation errors about player_id in this scenario, since form validation uses
          # TournamentPlayer object and not Player
          @player.skip_playerid_check = true
        end
      end

      @player.save
    end
  end

  def destroy
    @tournament = @player.tournament
    @player.destroy
  end

  def toggle_decklist
    @player.decklist = !@player.decklist
    @player.save!
    render partial: "tournaments/playerlist", locals: { tournament: @player.tournament }
  end

  private

  def load_player
    @player = TournamentPlayer.find(params[:id])
  end

  def load_tournament
    @tournament = Tournament.find(params[:tournament_id])
  end

  def tournament_player_params
    params.require(:tournament_player).permit(:name, :vekn, :player_id, :decklist, :country)
  end

end
