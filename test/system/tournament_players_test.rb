# frozen_string_literal: true
require "application_system_test_case"

class TournamentPlayersTest < ApplicationSystemTestCase

  test "add players to tournament" do
    p1 = create :player, name: "John Foo"
    p2 = create :player, name: "Bob Foo"
    p3 = create :player, name: "Ann Bar"
    p4 = build :player
    t = create :tournament

    login_to_tournaments
    assert_upcoming_tournament t.name
    click_link t.name
    assert_selector "h1", text: t.name

    within "div#playerlist" do
      click_button "Add players"
      fill_in "query", with: "foo"
      assert_selector "td", text: p1.name
      assert_selector "td", text: p2.name
      assert_no_selector "td", text: p3.name
      click_button "add-player-#{p1.id}"
      click_button "Done"
      assert_selector "h2", text: "1 player"
      assert_selector "td", text: p1.name

      click_button "Add players"
      fill_in "query", with: "x"
      click_button "Create new player entry"
      fill_in "tournament_player_name", with: p4.name
      fill_in "tournament_player_vekn", with: p4.vekn
      fill_in "tournament_player_email", with: p4.email
      select p4.country_name, from: "Country", match: :first
      click_button "Save"
      click_button "Done"
      assert_selector "h2", text: "2 players"
      assert_selector "td", text: p1.name
      assert_selector "td", text: p4.name
    end

    # make sure the new player was actually created
    click_link "Players"
    assert_selector "h1", text: "Players"
    assert_player_list p4
  end

  test "remove player from tournament" do
    t = create :tournament
    p1 = create :player
    p2 = create :player
    create_tournament_player(t, p1)
    create_tournament_player(t, p2)

    login_to_tournaments
    assert_upcoming_tournament t.name
    click_link t.name
    assert_selector "h1", text: t.name

    within "div#playerlist" do
      assert_selector "h2", text: "2 players"
      assert_selector "td", text: p1.name
      assert_selector "td", text: p2.name
      accept_confirm do
        click_button "remove-player-#{p1.id}"
      end
      assert_selector "h2", text: "1 player"
      assert_no_selector "td", text: p1.name
      assert_selector "td", text: p2.name
    end
  end
end
