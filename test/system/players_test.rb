require "application_system_test_case"

class PlayersTest < ApplicationSystemTestCase
  name = "John Doe"
  vekn = "1234567"
  country = "Antarctica"
  email = "john@example.com"

  test "add first player" do
    login
    click_link "Players"
    assert_selector "h1", text: "Players"
    within "div#players" do
      assert_selector "p", text: "No players found"
    end
    click_button "Add new player"

    assert_selector "h1", text: "New player"
    fill_in "Name", with: name
    fill_in "Vekn", with: vekn
    select country, from: "Country"
    fill_in "Email", with: email
    click_button "Save"

    within_table "players_table" do
      assert_selector "td", text: name
      assert_selector "td", text: vekn
      assert_selector "td", text: country
      assert_selector "td", text: email
    end
    # make sure turbo did not overwrite left-hand frame
    assert_selector "h1", text: "Players"
  end
end
