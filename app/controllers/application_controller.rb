class ApplicationController < ActionController::Base

  def check_authorized
    redirect_to login_path unless helpers.logged_in?
  end

  def log_player_create(player)
    Changelog.create(timestamp: Time.now,
                     change: "created player #{player.identifier}",
                     player_id: player.id)
  end

  def log_player_update(player, oldident)
    Changelog.create(timestamp: Time.now,
                     change: "updated player, #{oldident} -> #{player.identifier}",
                     player_id: player.id)
  end

  def log_player_delete(player)
    Changelog.create(timestamp: Time.now,
                     change: "deleted player #{player.identifier} (ID #{player.id})")
  end

  def log_tournament_create(tournament)
    Changelog.create(timestamp: Time.now,
                     change: "created tournament \"#{tournament.name}\"",
                     tournament_id: tournament.id)
  end

  def log_tournament_delete(tournament)
    Changelog.create(timestamp: Time.now,
                     change: "deleted tournament \"#{tournament.name}\" (ID #{tournament.id})")
  end

  def log_tournament_player_add(tp)
    Changelog.create(timestamp: Time.now,
                     change: "added #{tp.player.identifier} to \"#{tp.tournament.name}\"" +
                       (tp.confirmed ? "" : " (prereg)"),
                     tournament_id: tp.tournament_id,
                     player_id: tp.player_id)
  end

  def log_tournament_player_remove(tp)
    Changelog.create(timestamp: Time.now,
                     change: "removed #{tp.player.identifier} from \"#{tp.tournament.name}\"",
                     tournament_id: tp.tournament_id,
                     player_id: tp.player_id)
  end

end
