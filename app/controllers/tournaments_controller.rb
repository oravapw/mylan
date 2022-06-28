class TournamentsController < ApplicationController
  before_action :load_tournament, only: [:show, :edit, :update, :destroy,
                                         :show_players, :show_search, :search_players]

  def index
    load_tournaments
  end

  def show
  end

  def new
    @tournament = Tournament.new
  end

  def edit
  end

  def create
    @tournament = Tournament.new(tournament_params)
    if @tournament.save
      redirect_to tournaments_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if params[:cancel]
      redirect_to @tournament
      return
    end
    @tournament.assign_attributes(tournament_params)
    if @tournament.save
      redirect_to @tournament
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if params[:cancel]
      redirect_to @tournament
      return
    end
    @tournament.destroy
    redirect_to tournaments_path
  end

  def show_players
    render partial: "playerlist", locals: { tournament: @tournament}
  end

  def show_search
    render partial: "playersearch", locals: { tournament: @tournament}
  end

  def search_players
    query = params[:query]
    @results = nil
    if query.present?
      @results = []

      EcRegistration.includes(:name_meta, :vekn_meta)
                    .joins(:vekn_meta).where("wp_frm_item_metas.meta_value LIKE ?", "%#{query}%")
                    .or(EcRegistration.where("name LIKE ?", "%#{query}%")).find_each do |p|
        @results << SearchResult.new(name: p.name, vekn: p.vekn, prereg: true, player_id: p.id)
      end

      Player.where("name LIKE ?", "%#{query}%").or(Player.where("vekn LIKE ?", "%#{query}%")).find_each do |p|
        @results << SearchResult.new(name: p.name, vekn: p.vekn, prereg: false, player_id: p.id)
      end

      @results.sort_by!(&:name)

      # mark players already entered in this tournament
      added = {}
      @tournament.tournament_players.each do |p|
        added["#{p.player_id}:#{p.prereg}"] = 1
      end

      @results.each do |r|
        if added.include?("#{r.player_id}:#{r.prereg}")
          r.added = true
        end
      end
    end
  end

  private

  def load_tournament
    @tournament = Tournament.find(params[:id])
  end

  def load_tournaments
    @tournaments = Tournament.order("date desc", :name)
  end

  def tournament_params
    params.require(:tournament).permit(:name, :location, :organizers, :date, :decklists, :notes)
  end

end
