class SearchResult
  attr_accessor :name, :vekn, :player_id, :added

  def initialize(attrs)
    @name = attrs[:name]
    @vekn = attrs[:vekn]
    @player_id = attrs[:player_id]
  end
end
