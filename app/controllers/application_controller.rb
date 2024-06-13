class ApplicationController < ActionController::Base

  skip_forgery_protection

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

  def email_enabled?
    Rails.application.credentials.dig(:email, :enabled)
  end

  def send_registration_email(player)
    if email_enabled? && player.email.present?
      PlayerMailer.with(player: player, url: edit_registration_url(player.token)).register.deliver_later
    end
  end

end
