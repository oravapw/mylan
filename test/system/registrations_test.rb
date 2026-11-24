# frozen_string_literal: true
require "application_system_test_case"

class RegistrationsTest < ApplicationSystemTestCase

  test "player self-registration" do
    t = create :tournament
    p = create :player, name: "John Foo"
    assert 0, t.player_count

    # this should be accessible without login
    visit registration_url(t.prereg_slug)
    assert_selector "h1", text: "Registration for \"#{t.name}\""
    click_button "Register to this tournament"
    fill_in "query", with: "foo"
    click_button "add-player-#{p.id}"
    assert_selector "h1", text: "#{p.name} is registered for \"#{t.name}\""

    t.reload
    assert 1, t.player_count
    tp = t.tournament_players.first

    url = edit_registration_url(tp.token)
    assert_selector "a", text: url
    assert page.has_field? "email", with: p.email
    new_email = "foo@barbar.com"
    decklist = "This is a decklist"
    fill_in "email", with: new_email
    fill_in "decklist", with: decklist
    click_button "Save"

    p.reload
    tp.reload
    assert_equal new_email, p.email
    assert_equal new_email, tp.email
    assert_equal decklist, tp.decklist

    visit url
    assert_selector "h1", text: "#{p.name} is registered for \"#{t.name}\""
    assert page.has_field? "email", with: new_email
    assert page.has_field? "decklist", with: decklist

    # finally check that cancel works
    accept_confirm do
      click_button "Cancel registration"
    end
    assert_text "You have now been removed from tournament \"#{t.name}\""
    t.reload
    assert_equal 0, t.player_count
  end
end
