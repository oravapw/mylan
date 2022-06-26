class Player < ApplicationRecord
  before_validation :normalize_fields

  validates :name, presence: true, length: { maximum: 40 }
  validates :vekn, allow_nil: true, length: { is: 7 }, numericality: { only_integer: true }, uniqueness: true
  validates :country, allow_nil: true, length: { is: 2 }
  validate :validate_has_no_duplicate

  attr_accessor :duplicate_vekn_name

  def country_name
    if country.blank?
      ''
    else
      c = ISO3166::Country[country]
      c.translations[I18n.locale.to_s] || c.common_name || c.iso_short_name
    end
  end

  def identifier
    "#{name} / #{vekn} / #{country}"
  end

  def changelog_text
    "#{name},#{vekn},#{country}"
  end

  def normalize_fields
    self.name = name.blank? ? nil : name.strip
    self.vekn = vekn.blank? ? nil : vekn.strip.gsub(/\D/, '')
    self.country = country.blank? ? nil : country.strip
  end

  private

  def validate_has_no_duplicate
    if duplicate_vekn_name.present?
      errors.add(:base, :duplicate, message: "Pre-registered player #{duplicate_vekn_name} already has this VEKN")
    end
  end
end
