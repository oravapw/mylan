# frozen_string_literal: true
require "application_system_test_case"

class PlayersTest < ApplicationSystemTestCase

  test "add new player" do
    login_to_players
    assert_selector "p", text: "No players found"
    click_button "Add new player"
    assert_selector "h1", text: "New player"

    player = build :player
    fill_in "Name", with: player.name
    fill_in "Vekn", with: player.vekn
    select player.country_name, from: "Country", match: :first
    fill_in "Email", with: player.email
    click_button "Save"

    assert_player_list player

    # make sure turbo did not overwrite left-hand frame
    within "div#left" do
      assert_selector "h1", text: "Players"
    end
  end

  test "update existing player" do
    player = create :player

    login_to_players
    assert_player_list player

    click_link player.name
    assert_selector "div#player"
    within "div#player" do
      assert_selector "h1", text: player.name
      click_button "Edit"
    end

    assert_selector "div#player-edit"
    new_player = build :player
    within "div#player-edit" do
      assert_selector "h1", text: "Editing player #{player.name}"
      fill_in "Name", with: new_player.name
      fill_in "Vekn", with: new_player.vekn
      select new_player.country_name, from: "Country", match: :first
      fill_in "Email", with: new_player.email
      click_button "Save"
    end

    assert_player_list new_player
  end

  test "delete existing player" do
    player1 = create :player
    player2 = create :player

    login_to_players
    assert_player_list player1
    assert_player_list player2

    click_link player2.name
    within "div#player" do
      click_button "Edit"
    end

    within "div#player-edit" do
      accept_confirm do
        click_button "Delete"
      end
    end

    assert_player_list player1
    assert_no_player_list player2
  end

  test "search players" do
    player1 = create :player, name: "John Foo"
    player2 = create :player, name: "Bob Foo"
    player3 = create :player, name: "Ann Bar"

    login_to_players
    assert_player_list player1
    assert_player_list player2
    assert_player_list player3

    within "div#left" do
      fill_in "query", with: "foo"
    end

    assert_no_player_list player3
    assert_player_list player1
    assert_player_list player2

    within "div#left" do
      fill_in "query", with: "ann"
    end

    assert_player_list player3
    assert_no_player_list player1
    assert_no_player_list player2
  end
end
