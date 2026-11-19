require "application_system_test_case"

class TournamentsTest < ApplicationSystemTestCase

  test "add new minimal tournament" do
    login_to_tournaments
    click_button "Add new tournament"
    assert_selector "h1", text: "New tournament"
    name = "Test tournament"
    fill_in "tournament_name", with: name
    click_button "Save"

    assert_selector "h1", text: "Tournaments"
    assert_tournament "Date unknown", name

    click_link name
    within "div#tournament-info" do
      assert_selector "h1", text: name
      assert_selector "td#location", text: "-"
      assert_selector "td#organizer", text: "-"
      assert_selector "td#decklists", text: "No"
      assert_selector "td#decklists-viewable", text: "After tournament starts"
      assert_selector "td#proxies-allowed", text: "Yes"
      assert_selector "td#prereg", text: "No"
      assert_no_selector "td#prereg-end"
    end

    within "div#playerlist" do
      assert_selector "h2", text: "No players yet"
    end

    click_button "Back"
    assert_selector "h1", text: "Tournaments"
  end

  def login_to_tournaments
    login
    assert_selector "h1", text: "Tournaments"
  end

  def assert_tournament(group, name)
    assert_selector "div#tournaments-list"
    within_table "tournaments-table" do
      assert_selector "th", text: group
      assert_selector "td", text: name
    end
  end
end
