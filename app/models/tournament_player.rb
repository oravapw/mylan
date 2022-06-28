class TournamentPlayer < ApplicationRecord
  belongs_to :tournament

  validates :name, presence: true, length: { maximum: 40 }
  validates :vekn, allow_blank: true, length: { is: 7 }, numericality: { only_integer: true }, uniqueness: true
  validates :player_id, presence: true, numericality: { only_integer: true }
end
