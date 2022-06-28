class SearchResult
  attr_accessor :name, :vekn, :prereg, :player_id, :added

  def initialize(attrs)
    @name = attrs[:name]
    @vekn = attrs[:vekn]
    @prereg = attrs[:prereg]
    @player_id = attrs[:player_id]
  end
end
