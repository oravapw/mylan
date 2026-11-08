# frozen_string_literal: true
require "application_system_test_case"

class LoginTest < ApplicationSystemTestCase
  test "visit the login page" do
    visit login_url
    assert_selector "label.label", text: "Username:"
  end
end
