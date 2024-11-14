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

  def decklist_lines(decklist)
    decklist.present? ? "#{decklist.lines.count} lines" : "empty"
  end

  def decklist_check_color(decklist)
    decklist.present? && decklist.lines.count > 10 ? "green" : "orange"
  end

  def decklist_check_symbol(decklist)
    decklist.present? && decklist.lines.count > 10 ? "check" : "question"
  end
end
