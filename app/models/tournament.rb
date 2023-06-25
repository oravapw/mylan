class Tournament < ApplicationRecord
  has_many :tournament_players

  validates :name, presence: true, length: { maximum: 40 }, uniqueness: true
  validates :location, length: { maximum: 80 }
  validates :organizers, length: { maximum: 120 }
  validates :prereg_slug, uniqueness: true, allow_blank: true
  validate :check_prereg, if: :preregister?

  before_validation :initialize_prereg

  def player_count
    tournament_players.size
  end

  def today?
    date.present? ? date >= Time.now.beginning_of_day && date <= Time.now.end_of_day : false
  end

  def future?
    date.present? ? date > Time.now.end_of_day : false
  end

  def past?
    date.present? ? date < Time.now.beginning_of_day : false
  end

  def preregister?
    prereg?
  end

  def display_date
    if date.present?
      # this used to be just a date field, so old entries will have "zero" as time, or more
      # precisely the zero adjusted by Finnish time zone, leave those times out
      if date.min == 0 && date.hour.between?(2,3)
        date.strftime("%a %d.%m.%Y")
      else
        date.strftime("%a %d.%m.%Y (%H:%M)")
      end
    else
      ''
    end
  end

  def display_prereg_end
    prereg_end.present? ? prereg_end.strftime("%a %d.%m.%Y (%H:%M)") : ''
  end

  def has_players?
    !self.tournament_players.empty?
  end

  private

  def check_prereg
    if prereg_slug.blank?
      errors.add :prereg_slug, "must be non-blank"
    end

    if date.nil?
      errors.add :date, "tournament start must be specified for pre-registration"
    end

    if prereg_end.nil?
      errors.add :prereg_end, "must be specified"
    elsif date.present? && prereg_end > date
      errors.add :prereg_end, "cannot be after tournament start"
    end
  end

  def initialize_prereg
    return unless prereg?

    # set prereg slug from name if it is not set
    if prereg_slug.blank? && name.present?
      self.prereg_slug = name.strip.gsub(/\W/, '_').downcase
    end

    # set prereg end to be one hour before tournament start, if null
    if prereg_end.nil? && date.present?
      self.prereg_end = date - 1.hour
    end
  end
end
