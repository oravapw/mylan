# frozen_string_literal: true
module TournamentsHelper
  def decklist_delay_text(delay)
    if delay == 0
      "After tournament starts"
    elsif delay % 60 == 0
      h = delay / 60
      "#{h} #{'hour'.pluralize(h)} after tournament starts"
    elsif delay > 60 && delay % 30 == 0
      "#{delay / 60.0} hours after tournament starts"
    else
      "#{delay} minutes after tournament starts"
    end
  end

  def decklist_valid?(decklist)
    decklist.present? && decklist.lines.count > 10
  end

  def decklist_id(decklist, id)
    type = if decklist.present?
             decklist_valid?(decklist) ? "ok" : "bad"
           else
             "none"
           end
    "dl-#{id}-#{type}"
  end

  def decklist_lines(decklist)
    decklist.present? ? "#{decklist.lines.count} lines" : "empty"
  end

  def decklist_check_color(decklist)
    decklist_valid?(decklist) ? "green" : "orange"
  end

  def decklist_check_symbol(decklist)
    decklist_valid?(decklist) ? "check" : "question"
  end
end
