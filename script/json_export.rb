# frozen_string_literal: true

json = {
  players: Player.all.map { |i| i.as_json },
  tournaments: Tournament.all.map { |i| i.as_json },
  tournament_players: TournamentPlayer.all.map { |i| i.as_json }
}.to_json
puts json
