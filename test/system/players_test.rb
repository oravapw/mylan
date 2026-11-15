# frozen_string_literal: true
require "application_system_test_case"

class PlayersTest < ApplicationSystemTestCase
  name = "John Doe"
  vekn = "1234567"
  country = "Antarctica"
  email = "john@example.com"

  test "player crud" do
    login
    click_link "Players"
    within "div#left" do
      assert_selector "h1", text: "Players"
    end
    within "div#right" do
      assert_selector "p", text: "No players found"
    end
    click_button "Add new player"

    assert_selector "div#new-player"
    assert_selector "h1", text: "New player"
    fill_in "Name", with: name
    fill_in "Vekn", with: vekn
    select country, from: "Country"
    fill_in "Email", with: email
    click_button "Save"

    assert_selector "div#players-list"
    within_table "players_table" do
      assert_selector "td", text: name
      assert_selector "td", text: vekn
      assert_selector "td", text: country
      assert_selector "td", text: email
    end
    click_link name

    # make sure turbo did not overwrite left-hand frame
    within "div#left" do
      assert_selector "h1", text: "Players"
    end

    assert_selector "div#player"
    within "div#player" do
      assert_selector "h1", text: name
      click_button "Edit"
    end

    assert_selector "div#player-edit"
    within "div#player-edit" do
      assert_selector "h1", text: "Editing player #{name}"
    end
  end
end
