# frozen_string_literal: true
require "application_system_test_case"

class LoginTest < ApplicationSystemTestCase
  test "bad password" do
    login "badpassword"
    assert_selector "label.label", text: "Username:"
    within "div.notification" do
      assert_text "Username and/or password not valid"
    end
  end

  test "login successfully" do
    login
    assert_selector "h1", text: "Tournaments"
  end

  test "paths require login" do
    visit tournaments_url
    assert_selector "label.label", text: "Username:"
    visit players_url
    assert_selector "label.label", text: "Username:"
    visit decklists_url
    assert_selector "label.label", text: "Username:"
  end
end
