class PlayerMailer < ApplicationMailer
  default from: ENV["EMAIL_FROM"] if ENV["EMAIL_FROM"].present?

  def register
    @player = params[:player]
    @url = params[:url]
    @tournament = @player.tournament

    mail to: @player.email, subject: "Registration for #{@tournament.name}"
  end
end
