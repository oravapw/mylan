# frozen_string_literal: true

# copies over all EC prereg players to "actual" player table
# run with: rails r ./bin/post_ec2022_migrate.rb

copied = 0
ok = 0

EcRegistration.find_each do |reg|
  vekn = reg.vekn
  name = reg.name
  country = reg.country
  if vekn.present?
    player = Player.where(vekn: vekn).first
    if player.nil?
      short_country = case country
                      when "Finland"
                        "FI"
                      when "Austria"
                        "AT"
                      when "Sweden"
                        "SE"
                      when "Belgium"
                        "BE"
                      when "United Kingdom"
                        "GB"
                      when "Hungary"
                        "HU"
                      when "Spain"
                        "ES"
                      when "France"
                        "FR"
                      when "Italy"
                        "IT"
                      when "Czech Republic"
                        "CZ"
                      when "Australia"
                        "AU"
                      when "Denmark"
                        "DK"
                      when "Poland"
                        "PL"
                      when "United States"
                        "US"
                      when "Slovakia"
                        "SK"
                      when "Germany"
                        "DE"
                      else
                        nil
                      end
      puts "copying #{name} #{vekn} #{country} #{short_country}"
      player = Player.new(name: name, vekn: vekn, country: short_country)
      player.save!
      copied += 1
    else
      ok += 1
    end
  end
end

puts "copied #{copied} EC player entries, #{ok} entries were already copied"

# next change tournament player links to point to new player data
updated = 0
removed = 0
TournamentPlayer.where(prereg: true).find_each do |tp|
  if tp.vekn.blank?
    puts "would remove non-VEKN player #{tp.name} #{tp.country}"
    tp.destroy
    removed += 1
  else
    player = Player.where(vekn: tp.vekn).first
    if player.nil?
      puts "ERROR: no matching player entry found for old prereg #{tp.name} #{tp.vekn} #{tp.country}"
    else
      tp.player_id = player.id
      tp.prereg = false
      tp.save!
      updated += 1
    end
  end
end

puts "updated #{updated} tournament player entries, deleted #{removed} without VEKN number"
