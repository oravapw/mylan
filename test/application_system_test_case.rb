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

  def login_to_players
    login
    assert_selector "h1", text: "Tournaments"
    click_link "Players"
    assert_selector "h1", text: "Players"
  end

  def login_to_tournaments
    login
    assert_selector "h1", text: "Tournaments"
  end

  def assert_upcoming_tournament(name)
    assert_tournament "upcoming", "Upcoming", name
  end

  def assert_past_tournament(name)
    assert_tournament "past", "Past", name
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

  def assert_no_tournament(name)
    assert_selector "div#tournaments-list"
    within_table "tournaments-table" do
      assert_no_selector "td", text: name
    end
  end

  def assert_player_list(player)
    assert_selector "div#players-list"
    within_table "players-table" do
      assert_selector "td", text: player.name
      assert_selector "td", text: player.vekn
      assert_selector "td", text: player.country_name
      assert_selector "td", text: player.email
    end
  end

  def assert_no_player_list(player)
    assert_selector "div#players-list"
    within_table "players-table" do
      assert_no_selector "td", text: player.name
    end
  end

  def create_tournament_player(tournament, player, decklist = nil)
    TournamentPlayer.create!(name: player.name, vekn: player.vekn, player_id: player.id,
                             tournament_id: tournament.id, decklist: decklist)
  end
end
