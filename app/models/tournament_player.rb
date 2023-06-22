class TournamentPlayer < ApplicationRecord
  belongs_to :tournament

  attr_accessor :country
  attr_accessor :skip_playerid_check

  validates :name, presence: true, length: { maximum: 40 }
  validates :vekn, allow_blank: true, length: { is: 7 }, numericality: { only_integer: true }
  validates :player_id, presence: true, numericality: { only_integer: true }, unless: -> { skip_playerid_check }

  def self.update_player_data(player_id, name, vekn)
    self.where(player_id: player_id).find_each do |p|
      p.name = name
      p.vekn = vekn unless vekn.blank?
      p.save!
    end
  end

end
