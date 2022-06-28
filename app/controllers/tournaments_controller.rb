class TournamentsController < ApplicationController
  before_action :load_tournament, only: [:show, :edit, :update, :destroy]

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
