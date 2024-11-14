class Player < ApplicationRecord
  before_validation :normalize_fields

  validates :name, presence: true, length: { maximum: 40 }
  validates :vekn, allow_nil: true, length: { is: 7 }, numericality: { only_integer: true }, uniqueness: true
  validates :country, allow_nil: true, length: { is: 2 }

  def country_name
    if country.blank?
      ""
    else
      c = ISO3166::Country[country]
      c.translations[I18n.locale.to_s] || c.common_name || c.iso_short_name
    end
  end

  def identifier
    "#{name} / #{vekn} / #{country} / #{email}"
  end

  def normalize_fields
    self.name = name.blank? ? nil : name.strip
    self.vekn = vekn.blank? ? nil : vekn.strip.gsub(/\D/, "")
    self.country = country.blank? ? nil : country.strip
    self.email = email.blank? ? nil : email.strip
  end
end
