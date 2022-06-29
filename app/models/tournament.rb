class Tournament < ApplicationRecord
  has_many :tournament_players

  validates :name, presence: true, length: { maximum: 40 }
  validates :location, length: { maximum: 80 }
  validates :organizers, length: { maximum: 120 }

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

  def display_date
    date.present? ? date.strftime("%a %d.%m.%Y") : ''
  end

  def has_players?
    !self.tournament_players.empty?
  end
end
