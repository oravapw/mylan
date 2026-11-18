# frozen_string_literal: true
require "application_system_test_case"

class PlayersTest < ApplicationSystemTestCase
  name = "John Doe"
  vekn = "1234567"
  country = "Antarctica"
  email = "john@example.com"

  new_name = "John Wick"
  new_vekn = "6666666"
  new_country = "Russia"
  new_email = "wick@assassin.com"

  test "add new player" do
    login
    assert_selector "h1", text: "Tournaments"
    click_link "Players"
    sleep 1
    assert_no_selector "h1", text: "Tournaments"

    assert_selector "h1", text: "Players"
    assert_selector "p", text: "No players found"
    click_button "Add new player"
    sleep 1
    assert_no_selector "p", text: "No players found"

    assert_selector "h1", text: "New player"
    fill_in "Name", with: name
    fill_in "Vekn", with: vekn
    select country, from: "Country"
    fill_in "Email", with: email
    click_button "Save"
    assert_no_selector "h1", text: "New player"

    assert_player_list(name, vekn, country, email)

    # make sure turbo did not overwrite left-hand frame
    within "div#left" do
      assert_selector "h1", text: "Players"
    end

    # click_link name
    # assert_no_selector "div#players-list"
    #
    # assert_selector "div#player"
    # within "div#player" do
    #   assert_selector "h1", text: name
    #   click_button "Edit"
    # end
    # assert_no_selector "div#player"
    #
    # assert_selector "div#player-edit"
    # within "div#player-edit" do
    #   assert_selector "h1", text: "Editing player #{name}"
    #   fill_in "Name", with: new_name
    #   fill_in "Vekn", with: new_vekn
    #   select new_country, from: "Country"
    #   fill_in "Email", with: new_email
    #   click_button "Save"
    # end
    #
    # assert_player_list(new_name, new_vekn, new_country, new_email)
    #
    # click_link new_name
    # assert_no_selector "div#players-list"
    #
    # assert_selector "div#player"
    # within "div#player" do
    #   assert_selector "h1", text: new_name
    #   click_button "Edit"
    # end
    #
    # assert_no_selector "div#player"
    # assert_selector "div#player-edit"
    # within "div#player-edit" do
    #   assert_selector "h1", text: "Editing player #{new_name}"
    #   accept_confirm do
    #     click_button "Delete"
    #   end
    # end
    #
    # assert_selector "p", text: "No players found"
  end

  def assert_player_list(name, vekn, country, email)
    assert_selector "div#players-list"
    within_table "players_table" do
      assert_selector "td", text: name
      assert_selector "td", text: vekn
      assert_selector "td", text: country
      assert_selector "td", text: email
    end
  end
end
