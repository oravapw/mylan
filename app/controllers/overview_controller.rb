class OverviewController < ApplicationController

  before_action :check_authorized

  def index
    @prereg_count = EcRegistration.count
    @prereg_dupes = EcRegistration.select("name").group("name").having("count(name) > 1").map { |reg| reg.name }
    @preregs_by_country = EcRegistrationMeta.where(field_id: EcRegistrationMeta::COUNTRY_FIELD_ID).group(:meta_value).count
  end

end
