class ApplicationController < ActionController::Base

  def check_authorized
    redirect_to login_path unless helpers.logged_in?
  end

  def log_player_create(player)
    Changelog.create(timestamp: Time.now,
      change: "added player #{player.identifier}",
      player_id: player.id)
  end

  def log_player_update(player, oldident)
    Changelog.create(timestamp: Time.now,
      change: "updated player, #{oldident} -> #{player.identifier}",
      player_id: player.id)
  end

  def log_player_delete(player)
    Changelog.create(timestamp: Time.now,
      change: "deleted player #{player.identifier}",
      player_id: player.id)
  end

  def log_tournament_create(tournament)
    Changelog.create(timestamp: Time.now,
      change: "added tournament \"#{tournament.name}\"",
      tournament_id: tournament.id)
  end

  def log_tournament_delete(tournament)
    Changelog.create(timestamp: Time.now,
      change: "deleted tournament \"#{tournament.name}\"",
      tournament_id: tournament.id)
  end
end
