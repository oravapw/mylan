# frozen_string_literal: true
class ApplicationController < ActionController::Base
  def check_authorized
    redirect_to login_path unless helpers.logged_in?
  end

  def email_enabled?
    ENV["SMTP_ADDRESS"].present?
  end

  def send_registration_email(player)
    return unless email_enabled? && player.email.present? && player.token.present?

    PlayerMailer.with(player: player, url: edit_registration_url(player.token)).register.deliver_later
  end

  def like(field, pattern)
    ["#{field.to_s} ILIKE ?", "%#{pattern}%"]
  end
end
