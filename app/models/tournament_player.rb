class TournamentPlayer < ApplicationRecord
  belongs_to :tournament

  validates :name, presence: true, length: { maximum: 40 }
  validates :vekn, allow_blank: true, length: { is: 7 }, numericality: { only_integer: true }
  validates :player_id, presence: true, numericality: { only_integer: true }

  def self.update_player_data(player_id, prereg, name, vekn)
    self.where(player_id: player_id, prereg: prereg).find_each do |p|
      p.name = name
      p.vekn = vekn
      p.save!
    end
  end

end
