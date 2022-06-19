# frozen_string_literal: true
class EcdataRecord < ActiveRecord::Base
  self.abstract_class = true
  connects_to database: { writing: :ecdata}
end

