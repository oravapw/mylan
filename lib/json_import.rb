# frozen_string_literal: true

file = ARGV.first
unless file
  puts "Usage: json_import.rb <jsonfile>"
  exit 1
end

if Player.count > 0 || Tournament.count > 0 || TournamentPlayer.count > 0
  puts "database must be empty in order to import from JSON"
  exit 1
end

json = JSON.parse(File.read(file))

players = json["players"]
puts "importing #{players.length} players"
players.each { |p| Player.create!(p) }

tournaments = json["tournaments"]
puts "importing #{tournaments.length} tournaments"
tournaments.each { |t| Tournament.create!(t) }

tournament_players = json["tournament_players"]
puts "importing #{tournament_players.length} tournament players"
tournament_players.each { |tp| TournamentPlayer.create!(tp) }
