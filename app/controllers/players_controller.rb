class PlayersController < ApplicationController
  before_action :load_player, only: [:edit, :update, :destroy]
  before_action :redirect_cancel, only: [:create, :update]

  def index
    @query = params[:query]
    if @query.present?
      @players = Player.where("name LIKE ?", "%#{@query}%").or(Player.where("vekn LIKE ?", "%#{@query}%"))
                       .order(:name).page params[:page]
    else
      @players = Player.order(:name).page params[:page]
    end

    if turbo_frame_request?
      render partial: "players", locals: { players: @players, query: @query }
    end
  end

  def new
    @player = Player.new
  end

  def edit
    @page = params[:page]
    @query = params[:query]
  end

  def create
    @player = Player.new(player_params)
    check_vekn_vs_registred(@player)
    if @player.save
      Changelog.create(change_type: :add, player_type: :normal, row_id: @player.id,
        oldvalues: nil, newvalues: @player.changelog_text)
      redirect_to players_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    oldvalues = @player.changelog_text
    @player.assign_attributes(player_params)
    check_vekn_vs_registred(@player)
    changed = @player.changelog_text != oldvalues
    if @player.save
      Changelog.create(change_type: :edit, player_type: :normal, row_id: @player.id,
        oldvalues: oldvalues, newvalues: @player.changelog_text) if changed
      redirect_to players_path(page: params[:page], query: params[:query])
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    row_id = @player.id
    ident = @player.identifier
    oldvalues = @player.changelog_text
    @player.destroy
    Changelog.create(change_type: :remove, player_type: :normal, row_id: row_id, oldvalues: oldvalues)
    redirect_to players_path, alert: "Deleted #{ident}"
  end

  private

  def load_player
    @player = Player.find(params[:id])
  end

  def player_params
    params.require(:player).permit(:name, :vekn, :country)
  end

  def redirect_cancel
    redirect_to players_path(page: params[:page], query: params[:query]) if params[:cancel]
  end

  def check_vekn_vs_registred(player)
    player.normalize_fields
    if player.vekn.present?
      prereg_meta = EcRegistrationMeta.where(field_id: EcRegistrationMeta::VEKN_FIELD_ID, meta_value: player.vekn).first
      if prereg_meta.present?
        name = EcRegistration.find(prereg_meta.item_id)&.name
        logger.debug("XXX: conflict with #{name}")
        player.duplicate_vekn_name = name
      end
    end
  end

end
