class Tournament < ApplicationRecord
  has_many :tournament_players

  validates :name, presence: true, length: { maximum: 40 }, uniqueness: true
  validates :location, length: { maximum: 80 }
  validates :organizers, length: { maximum: 120 }
  validates :prereg_slug, uniqueness: true, allow_blank: true
  validate :check_prereg, if: :prereg?

  before_validation :initialize_prereg

  scope :not_future, -> { where(date: ..Time.now) }

  def player_count
    tournament_players.size
  end

  def decklist_count
    tournament_players.select { |p| p.decklist.present? }.size
  end

  def missing_decklist_count
    player_count - decklist_count
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

  def prereg_open?
    prereg? && prereg_end&.future?
  end

  def prereg_closed?
    prereg? && prereg_end&.past?
  end

  def display_date(only_compact_date = false)
    if date.present?
      if only_compact_date
        date.strftime("%d.%m.%Y")
      elsif date.min == 0 && date.hour.between?(2, 3)
        # this used to be just a date field, so old entries will have "zero" as time, or more
        # precisely the zero adjusted by Finnish time zone, leave those times out
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

  def has_unconfirmed_players?
    self.tournament_players.find { |tp| !tp.confirmed? }.present?
  end

  def unconfirmed_players
    self.tournament_players.select { |tp| !tp.confirmed? }
  end

  def decklists_visible?
    date < Time.now
  end

  def generate_slug
    name.strip.gsub(/\W/, '_').downcase
  end

  def notes_as_html
    Kramdown::Document.new(notes).to_html.html_safe
  end

  def prereg_info_as_html
    kramdoc2html Kramdown::Document.new(prereg_info)
  end

  class MyHtmlConverter < Kramdown::Converter::Html
    def convert_a(el, indent)
      format_as_span_html("a", el.attr.merge('target': '_blank'), inner(el, indent))
    end
  end

  private

  def kramdoc2html(doc)
    html, _ = MyHtmlConverter.convert(doc.root, {})
    html.html_safe
  end

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
      self.prereg_slug = generate_slug
    end

    # set prereg end to be one hour before tournament start, if null
    if prereg_end.nil? && date.present?
      self.prereg_end = date - 1.hour
    end
  end

end
