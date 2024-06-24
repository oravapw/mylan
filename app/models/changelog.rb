# == Schema Information
#
# Table name: changelogs
#
#  id            :bigint           not null, primary key
#  change        :string(255)      not null
#  timestamp     :datetime         not null
#  player_id     :bigint
#  tournament_id :bigint
#
# Indexes
#
#  index_changelogs_on_player_id      (player_id)
#  index_changelogs_on_tournament_id  (tournament_id)
#
# Foreign Keys
#
#  fk_rails_...  (player_id => players.id) ON DELETE => nullify
#  fk_rails_...  (tournament_id => tournaments.id) ON DELETE => nullify
#
class Changelog < ApplicationRecord
  validates :timestamp, presence: true
  validates :change, presence: true, length: { maximum: 255 }

  belongs_to :player, optional: true
  belongs_to :tournament, optional: true
end
