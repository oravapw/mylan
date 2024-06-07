class PlayerMailer < ApplicationMailer
  if Rails.application.credentials.dig(:email, :default_from).present?
    default from: Rails.application.credentials.dig(:email, :default_from)
  end

  def register
    @player = params[:player]
    @url = params[:url]
    @tournament = @player.tournament

    mail to: @player.email, subject: "Registration for #{@tournament.name}"
  end
end
