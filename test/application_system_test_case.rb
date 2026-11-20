# frozen_string_literal: true
require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_firefox, screen_size: [1400, 1400]

  include FactoryBot::Syntax::Methods
  include ActionView::Helpers::DateHelper

  def login(password = "mylan")
    visit login_url
    fill_in "Username:", with: "mylan"
    fill_in "Password:", with: password
    click_button "Login"
  end
end
