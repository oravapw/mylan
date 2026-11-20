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
    assert_unknown_tournament name

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

  test "add new tournament" do
    login_to_tournaments
    click_button "Add new tournament"
    assert_selector "h1", text: "New tournament"

    name = "Test tournament"
    time = 7.days.from_now
    decklists_viewable = "1 hour after tournament starts"
    location = "Some place"
    organizers = "Some organizers"
    notes = "Hello *world*"
    prereg_close = 6.days.from_now
    prereg_info = "Some **bold** info"

    fill_in "tournament_name", with: name
    fill_in "tournament_date", with: time
    check "tournament_decklists"
    select decklists_viewable, from: "tournament_decklist_delay", match: :first
    uncheck "tournament_proxies"
    fill_in "tournament_location", with: location
    fill_in "tournament_organizers", with: organizers
    fill_in "tournament_notes", with: notes
    check "tournament_prereg"
    fill_in "tournament_prereg_end", with: prereg_close
    fill_in "tournament_prereg_info", with: prereg_info

    click_button "Save"

    assert_selector "h1", text: "Tournaments"
    assert_upcoming_tournament name

    click_link name
    within "div#tournament-info" do
      assert_selector "h1", text: name
      assert_selector "h2", text: time.strftime("%a %d.%m.%Y (%H:%M)") +
        ", #{distance_of_time_in_words_to_now(time)} from now"

      assert_selector "td#location", text: location
      assert_selector "td#organizer", text: organizers
      assert_selector "td#decklists", text: "Yes"
      assert_selector "td#decklists-viewable", text: decklists_viewable
      assert_selector "td#proxies-allowed", text: "No"
      assert_selector "td#prereg", text: "Yes"
      assert_selector "td#prereg-end", text: prereg_close.strftime("%a %d.%m.%Y (%H:%M)")
      assert_selector "a", text: registration_url("test_tournament")
    end
    assert page.html.include?("Hello <em>world</em>")
    assert page.html.include?("Some <strong>bold</strong> info")
  end

  def login_to_tournaments
    login
    assert_selector "h1", text: "Tournaments"
  end

  def assert_upcoming_tournament(name)
    assert_tournament "upcoming", "Upcoming", name
  end

  def assert_unknown_tournament(name)
    assert_tournament "unknown", "Date unknown", name
  end

  def assert_tournament(group, title, name)
    assert_selector "div#tournaments-list"
    within_table "tournaments-table" do
      assert_selector "th.#{group}-title", text: title
      assert_selector "td.#{group}", text: name
    end
  end
end
