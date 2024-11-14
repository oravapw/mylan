require "zip"

class DecklistsController < ApplicationController
  before_action :check_authorized

  def index
    @tournaments = Tournament.not_future
                             .joins(:tournament_players)
                             .includes(:tournament_players)
                             .merge(TournamentPlayer.with_decklist)
                             .order("date desc", :name)
                             .distinct
                             .select { |t| t.decklists_visible? }
    @tournament_players = TournamentPlayer.group(:tournament_id).count
  end

  def tournament_index
    @tournament = Tournament.find(params[:id])
    if @tournament.present?
      if @tournament.decklists_visible?
        @players = @tournament.tournament_players.with_decklist.order(:name).all
      else
        flash[:alert] = "Tournament decklists now viewable yet"
        redirect_to decklists_path
      end
    else
      flash[:alert] = "No such tournament"
      redirect_to decklists_path
    end
  end

  def show
    @player = TournamentPlayer.find(params[:id])
    @player = nil unless @player.tournament.decklists_visible?
  end

  def download
    player = TournamentPlayer.find(params[:id])
    send_data player.decklist, filename: player.decklist_filename, type: "text/plain"
  end

  def download_combined
    delim = "\n\n" + ("- " * 40) + "\n\n"
    tournament = Tournament.find(params[:id])
    decklists = tournament.tournament_players.with_decklist.order(:name)
                          .map { |p| p.decklist.strip }
                          .join(delim)
    filename = "decklists_#{tournament.generate_slug}.txt"
    send_data decklists, filename: filename, type: "text/plain"
  end

  def download_zip
    tournament = Tournament.find(params[:id])
    players = tournament.tournament_players.with_decklist.order(:name)
    Zip.unicode_names = true
    buffer = Zip::OutputStream.write_buffer do |stream|
      players.each_with_index do |player, index|
        filename = player.decklist_filename(index + 1)
        stream.put_next_entry(filename)
        stream.write(player.decklist.strip + "\n")
      end
    end
    buffer.rewind
    send_data buffer.read, filename: "decklists_#{tournament.generate_slug}.zip"
  end
end
