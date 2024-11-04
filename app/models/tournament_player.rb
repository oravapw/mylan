# == Schema Information
#
# Table name: tournament_players
#
#  id            :bigint           not null, primary key
#  confirmed     :boolean          default(FALSE), not null
#  decklist      :text(65535)
#  email         :string(255)
#  name          :string(40)       not null
#  token         :string(255)
#  vekn          :string(7)
#  player_id     :bigint           not null
#  tournament_id :bigint           not null
#
# Indexes
#
#  index_tournament_players_on_token          (token) UNIQUE
#  index_tournament_players_on_tournament_id  (tournament_id)
#
require 'securerandom'

class TournamentPlayer < ApplicationRecord
  belongs_to :tournament
  belongs_to :player, optional: true

  attr_accessor :country
  attr_accessor :skip_playerid_check

  validates :name, presence: true, length: { maximum: 40 }
  validates :vekn, allow_blank: true, length: { is: 7 }, numericality: { only_integer: true }
  validates :player_id, presence: true, numericality: { only_integer: true }, unless: -> { skip_playerid_check }

  scope :with_decklist, -> { where.not(decklist: nil) }

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

  def first_name
    name.split(' ').first
  end

  def last_name
    name.split(' ').last
  end

  def decklist_name
    return nil if decklist.blank?
    re = /^\s*deck name:\s(.+)\s$/i
    decklist.each_line do |line|
      match = re.match(line)
      return match[1] if match
    end
    nil
  end

  def decklist_filename(counter = nil)
    nameslug = name.strip.gsub(/\W/, '_').downcase
    c = counter.nil? ? '' : "_#{'%02d' % counter}"
    "decklist_#{tournament.generate_slug}#{c}_#{nameslug}.txt"
  end
end
