class TournamentPlayersController < ApplicationController
  before_action :load_player, only: %i[destroy toggle_confirm edit_decklist update_decklist resend_link]
  before_action :load_tournament, only: %i[new create]

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
      @prereg_error = if @tournament.prereg_closed?
                        "Registration to this tournament has closed"
      else
                        "Registration to this tournament is not possible"
      end
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

    log_tournament_player_add @player if @player.save

    send_registration_email(@player) if @prereg
  end

  def destroy
    @tournament = @player.tournament
    @player.destroy
    log_tournament_player_remove @player
  end

  def resend_link
    send_registration_email(@player)
  end

  def toggle_confirm
    @player.confirmed = !@player.confirmed
    @player.save!
    render partial: "tournaments/playerlist", locals: { tournament: @player.tournament }
  end

  def edit_decklist
    return if @player.tournament.decklists_visible?

    flash.now[:alert] = "Decklists for this tournament are not visible yet!"
    render partial: "tournaments/playerlist", locals: { tournament: @player.tournament }
  end

  def update_decklist
    decklist = params[:decklist]
    if decklist.present? && !params[:cancel]
      @player.decklist = decklist
      @player.save!
    end
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
