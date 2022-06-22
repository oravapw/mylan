class Changelog < ApplicationRecord
  enum change_type: { add: 0, edit: 1, remove: 2}
  enum player_type: { normal: 0, prereg: 1 }

  validates :change_type, presence: true
  validates :player_type, presence: true
end
