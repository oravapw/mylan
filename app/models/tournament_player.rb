require 'securerandom'

class TournamentPlayer < ApplicationRecord
  belongs_to :tournament
  belongs_to :player, optional: true

  attr_accessor :country
  attr_accessor :skip_playerid_check

  validates :name, presence: true, length: { maximum: 40 }
  validates :vekn, allow_blank: true, length: { is: 7 }, numericality: { only_integer: true }
  validates :player_id, presence: true, numericality: { only_integer: true }, unless: -> { skip_playerid_check }

  def self.update_player_data(player_id, name, vekn, email)
    self.where(player_id: player_id).find_each do |p|
      p.name = name
      p.vekn = vekn unless vekn.blank?
      p.email = email unless email.blank?
      p.save!
    end
  end

  def country_name
    if country.blank?
      ''
    else
      c = ISO3166::Country[country]
      c.translations[I18n.locale.to_s] || c.common_name || c.iso_short_name
    end
  end

  def generate_token!
    self.token = SecureRandom.hex(16)
  end

  def ready_to_play?
    if tournament.decklists && decklist.blank?
      false
    else
      !tournament.prereg || confirmed?
    end
  end
end
