# frozen_string_literal: true
require "test_helper"
require "csv"

class TournamentsControllerTest < ActionDispatch::IntegrationTest

  test "generates randomized CSV" do
    t = create :tournament
    20.times do
      p = create :player
      TournamentPlayer.create!(name: p.name, vekn: p.vekn, player_id: p.id, tournament_id: t.id)
    end

    post authenticate_path, params: { username: "mylan", password: "mylan" }
    assert_redirected_to root_path

    post archon_csv_tournament_url(id: t.id, format: :csv)
    assert_equal "text/csv", @response.media_type
    csv = CSV.parse(@response.body)
    assert_equal 20, csv.size

    # make sure the results are actually randomized
    text = csv.to_s
    tries = 0
    loop do
      post archon_csv_tournament_url(id: t.id, format: :csv)
      assert_equal "text/csv", @response.media_type
      text2 = CSV.parse(@response.body).to_s
      break if text != text2
      flunk "CSV does not seem to be randomized" if ++tries > 10
    end
  end
end
