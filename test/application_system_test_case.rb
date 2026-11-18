# frozen_string_literal: true
require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]
  # driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400], options: {
  #   browser: :remote,
  #   url: "http://chrome-server:4444"
  # }

  def login(password = "mylan")
    visit login_url
    fill_in "Username:", with: "mylan"
    fill_in "Password:", with: password
    click_button "Login"
  end
end
