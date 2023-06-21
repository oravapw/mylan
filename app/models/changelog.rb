class Changelog < ApplicationRecord
  enum change_type: { add: 0, edit: 1, remove: 2 }

  validates :change_type, presence: true

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

end
