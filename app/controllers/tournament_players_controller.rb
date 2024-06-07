class TournamentPlayersController < ApplicationController

  before_action :load_player, only: [:destroy, :toggle_confirm]
  before_action :load_tournament, only: [:new, :create]

  def new
    @prereg = (params[:prereg] == "true")
    @player = TournamentPlayer.new(confirmed: !@prereg)
  end

  # this is a bit weird, since we handle multiple scenarios here and the result processing is with turbo streams
  def create
    @cancel = params[:cancel]
    return if @cancel

    # base functionality has us just creating  tournament-specific player and linking it in
    @player = TournamentPlayer.new(tournament_player_params)
    @player.generate_token!
    @prereg = !@player.confirmed?

    if @prereg && !@tournament.prereg_open?
      @prereg_error = @tournament.prereg_closed? ?
                        "Registration to this tournament has closed" : "Registration to this tournament is not possible"
      return
    end

    @player.tournament = @tournament

    # optionally create an "actual" player object (this is when user selects "Add new" option on search)
    if params[:create_player] == "true"
      @baseplayer = Player.new
      @baseplayer.name = @player.name
      @baseplayer.vekn = @player.vekn
      @baseplayer.country = @player.country
      @baseplayer.email = @player.email
      if @baseplayer.save
        @player.player_id = @baseplayer.id
        log_player_create @baseplayer
      else
        # do not show validation errors about player_id in this scenario, since form validation uses
        # TournamentPlayer object and not Player
        @player.skip_playerid_check = true
      end
    end

    if @player.save
      log_tournament_player_add @player
    end

    send_registration_email(@player) if @prereg
  end

  def destroy
    @tournament = @player.tournament
    @player.destroy
    log_tournament_player_remove @player
  end

  # def toggle_decklist
  #   @player.decklist = !@player.decklist
  #   @player.save!
  #   render partial: "tournaments/playerlist", locals: { tournament: @player.tournament }
  # end

  def toggle_confirm
    @player.confirmed = !@player.confirmed
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
    params.require(:tournament_player).permit(:name, :vekn, :player_id, :country, :email, :confirmed, :decklist)
  end

end
