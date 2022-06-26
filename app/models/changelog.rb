class Changelog < ApplicationRecord
  enum change_type: { add: 0, edit: 1, remove: 2 }
  enum player_type: { normal: 0, prereg: 1 }

  validates :change_type, presence: true
  validates :player_type, presence: true

  def change_type_icon
    case change_type
      when "add"
        "user-plus"
      when "remove"
        "trash"
      else
        "edit"
    end
  end

  def player_type_display
    normal? ? "Other" : "Prereg"
  end

  def player_type_class
    normal? ? "has-text-success" : "has-text-link"
  end
end
