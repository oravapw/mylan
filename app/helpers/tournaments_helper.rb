module TournamentsHelper

  def decklist_delay_text(delay)
    if delay == 0
      "After tournament starts"
    else
      if delay % 60 == 0
        h = delay / 60
        "#{h} #{'hour'.pluralize(h)} after tournament starts"
      elsif delay > 60 && delay % 30 == 0
        "#{delay / 60.0} hours after tournament starts"
      else
        "#{delay} minutes after tournament starts"
      end
    end
  end

end
