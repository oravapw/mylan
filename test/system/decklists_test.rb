# frozen_string_literal: true
require "application_system_test_case"

class DecklistsTest < ApplicationSystemTestCase

  test "decklists for future tournament" do
    t = create :tournament
    p1 = create :player
    p2 = create :player
    p3 = create :player

    create_tournament_player(t, p1)
    create_tournament_player(t, p2, make_decklist(2))
    create_tournament_player(t, p3, make_decklist(20))

    login_to_tournaments
    assert_upcoming_tournament t.name
    click_link t.name
    assert_selector "h1", text: t.name

    within "div#playerlist" do
      assert_selector "span#dl-#{p1.id}-none"
      assert_selector "span#dl-#{p2.id}-bad"
      assert_selector "span#dl-#{p3.id}-ok"
      # should not be editable, tournament in future
      assert_no_selector "button#dledit-#{p1.id}"
      assert_no_selector "button#dledit-#{p2.id}"
      assert_no_selector "button#dledit-#{p3.id}"
    end
  end

  test "decklists for past tournament" do
    t = create :past_tournament
    p1 = create :player
    p2 = create :player
    p3 = create :player

    tp1 = create_tournament_player(t, p1)
    tp2 = create_tournament_player(t, p2, make_decklist(2))
    tp3 = create_tournament_player(t, p3, make_decklist(20))

    login_to_tournaments
    assert_past_tournament t.name
    click_link t.name
    assert_selector "h1", text: t.name

    new_dl = make_decklist(20)
    within "div#playerlist" do
      assert_selector "span#dl-#{p1.id}-none"
      assert_selector "span#dl-#{p2.id}-bad"
      assert_selector "span#dl-#{p3.id}-ok"
      assert_selector "button#dledit-#{p1.id}"
      assert_selector "button#dledit-#{p2.id}"
      assert_selector "button#dledit-#{p3.id}"

      click_button "dledit-#{p1.id}"
      assert_selector "h2", text: "Deck list for #{p1.name}"
      fill_in "decklist", with: new_dl
      click_button "Update"
      assert_selector "span#dl-#{p1.id}-ok"
      tp1.reload
      assert_equal new_dl, tp1.decklist
    end

    click_link "Decklists"
    assert_selector "h1", text: "Decklists"
    click_link t.name
    assert_selector "h1", text: "Decklists for #{t.name}"
    assert_selector "a#dl-#{p1.id}"
    assert_selector "a#dl-#{p2.id}"
    assert_selector "a#dl-#{p3.id}"

    click_link "dl-#{p1.id}"
    assert_selector "h2", text: "Decklist for #{p1.name}"
    assert_selector "a", text: "Decklists"
    assert_selector "pre", text: new_dl
  end

  test "decklist visibility delay" do
    # future tournament, should not be visible
    t1 = create :tournament, date: Time.now.advance(minutes: 5), decklist_delay: 0
    create_tournament_player(t1, create(:player), make_decklist(20))

    # tournament started, delay 0, should be visible
    t2 = create :tournament, date: Time.now.advance(minutes: -1), decklist_delay: 0
    create_tournament_player(t2, create(:player), make_decklist(20))

    # tournament started, delay 30, should be visible but not linked
    t3 = create :tournament, date: Time.now.advance(minutes: -1), decklist_delay: 30
    create_tournament_player(t3, create(:player), make_decklist(20))

    # tournament started but delay time is over, should be visible
    t4 = create :tournament, date: Time.now.advance(minutes: -35), decklist_delay: 30
    create_tournament_player(t4, create(:player), make_decklist(20))

    login_to_tournaments
    click_link "Decklists"
    # future tournament, not in list at all
    assert_no_selector "em", text: t1.name
    assert_no_selector "a", text: t1.name

    # these should be visible
    assert_selector "a", text: t2.name
    assert_selector "em", text: t3.name
    assert_selector "a", text: t4.name
  end

  def make_decklist(size)
    list = []
    size.times do
      list << Faker::Lorem.sentence(supplemental: true, random_words_to_add: 4)
    end
    list.join "\n"
  end
end
