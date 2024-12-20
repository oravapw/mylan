require "csv"

class TournamentsController < ApplicationController
  before_action :check_authorized, except: [ :search_players ]
  before_action :load_tournament, only: %i[show edit update destroy
                                           show_players show_search search_players
                                           archon_csv unconfirmed_sheet]
  before_action :redirect_cancel, only: %i[create update]

  def index
    load_tournaments
  end

  def show
    @page_title_extra = "tournament \"#{@tournament.name}\""
  end

  def new
    @tournament = Tournament.new
    @tournament.proxies = true # default to allowing proxies
  end

  def edit; end

  def create
    @tournament = Tournament.new(tournament_params)
    if @tournament.save
      log_tournament_create @tournament
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
    log_tournament_delete @tournament
    redirect_to tournaments_path
  end

  def show_players
    render partial: "playerlist", locals: { tournament: @tournament }
  end

  def show_search
    render partial: "playersearch", locals: { tournament: @tournament }
  end

  def search_players
    query = params[:query]
    @prereg = params[:prereg]
    @results = nil
    return unless query.present?

    @results = []
    Player.where("name LIKE ?",
                 "%#{query}%").or(Player.where("vekn LIKE ?", "%#{query}%")).order(:name).find_each do |p|
      @results << SearchResult.new(name: p.name, vekn: p.vekn, email: p.email, player_id: p.id)
    end

    # mark players already entered in this tournament
    added = {}
    @tournament.tournament_players.each do |p|
      added[p.player_id] = 1
    end

    @results.each do |r|
      r.added = true if added.include?(r.player_id)
    end
  end

  # randomize player list and dump as CSV in suitable form for Archon cut+paste into Methuselahs tab
  def archon_csv
    respond_to do |format|
      format.csv do
        csv_string = CSV.generate do |csv|
          @tournament.tournament_players.all.shuffle.each.with_index(1) do |p, index|
            # need to split name into fist and last name, just do simple logic of assuming last word is last name
            parts = p.name.split
            first_name = if parts.count > 1
                           p.name.split[0..-2].join(" ")
            else
                           p.name
            end
            last_name = if parts.count > 1
                          parts.last
            else
                          ""
            end
            csv << [ index, first_name, last_name, "", p.vekn ]
          end
        end
        tname = @tournament.name.gsub(/[^\da-z]/i, "-").downcase
        send_data csv_string, filename: "#{tname}-random.csv", type: "text/csv"
      end
    end
  end

  def unconfirmed_sheet
    @page_title_extra = "Confirmation sheet for \"#{@tournament.name}\""
    render layout: "print"
  end

  private

  def load_tournament
    @tournament = Tournament.find(params[:id])
  end

  def load_tournaments
    @tournaments = Tournament.order("date desc", :name)
  end

  def tournament_params
    params.require(:tournament).permit(:name, :location, :organizers, :date, :decklists, :notes,
                                       :prereg, :prereg_slug, :prereg_info, :prereg_end, :proxies,
                                       :decklist_delay)
  end

  def redirect_cancel
    redirect_to tournaments_path if params[:cancel]
  end
end
