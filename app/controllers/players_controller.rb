class PlayersController < ApplicationController
  before_action :check_authorized
  before_action :store_page_and_query
  before_action :load_player, only: %i[show edit update destroy]
  before_action :redirect_cancel, only: %i[edit create update]

  def index
    load_paged_players
    return unless turbo_frame_request?

    render partial: "players", locals: { players: @players, query: @query, page: @page }
  end

  def show
    @page_title_extra = "player \"#{@player.name}\""
    ids = TournamentPlayer.select("distinct tournament_id").where(player_id: @player.id).map { |t| t.tournament_id }
    @tournaments = Tournament.where(id: ids).order("date") if ids.present?
    return unless turbo_frame_request?

    render partial: "player", locals: { player: @player, query: @query, page: @page,
                                        title: helpers.page_title(@page_title_extra) }
  end

  def new
    @player = Player.new
  end

  def edit; end

  def create
    @player = Player.new(player_params)
    @player.normalize_fields
    if @player.save
      log_player_create @player
      respond_to do |format|
        format.html { redirect_to players_path }
        format.turbo_stream { load_paged_players }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    oldident = @player.identifier
    @player.assign_attributes(player_params)
    @player.normalize_fields
    changed = @player.identifier != oldident
    if @player.save
      if changed
        log_player_update @player, oldident
        TournamentPlayer.update_player_data(@player.id, @player.name, @player.vekn, @player.email)
      end
      redirect_to players_path(page: params[:page], query: params[:query])
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @ident = @player.identifier
    @player.destroy
    log_player_delete @player
    respond_to do |format|
      format.html { redirect_to players_path }
      format.turbo_stream { load_paged_players }
    end
  end

  private

  def load_player
    @player = Player.find(params[:id])
  end

  def player_params
    params.require(:player).permit(:name, :vekn, :country, :email)
  end

  def redirect_cancel
    redirect_to players_path(page: params[:page], query: params[:query]) if params[:cancel]
  end

  def store_page_and_query
    @query = params[:query]
    @page = params[:page]
    logger.debug "setting page=#{@page}, query=#{@query}"
  end

  def load_paged_players
    pg = params[:page] || @page
    @players = if @query.present?
                 Player.where("name LIKE ?", "%#{@query}%").or(Player.where("vekn LIKE ?", "%#{@query}%"))
                       .order(:name).page pg
    else
                 Player.order(:name).page pg
    end
  end
end
