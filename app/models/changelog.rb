class Changelog < ApplicationRecord
  validates :timestamp, presence: true
  validates :change, presence: true, length: { maximum: 255 }

  belongs_to :player, optional: true
  belongs_to :tournament, optional: true
end
