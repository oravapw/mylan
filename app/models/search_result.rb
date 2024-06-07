class SearchResult
  attr_accessor :name, :vekn, :email, :player_id, :added

  def initialize(attrs)
    @name = attrs[:name]
    @vekn = attrs[:vekn]
    @email = attrs[:email]
    @player_id = attrs[:player_id]
  end
end
