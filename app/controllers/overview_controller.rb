class OverviewController < ApplicationController

  before_action :check_authorized

  def index
    @prereg_count = EcRegistration.count
    @prereg_dupes = EcRegistration.select("name").group("name").having("count(name) > 1").map {|reg| reg.name }
  end

end
