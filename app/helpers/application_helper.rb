module ApplicationHelper

  def navtabs
    [
      { label: "Tournaments", path: tournaments_path },
      { label: "Players", path: players_path },
      { label: "Decklists", path: decklists_path }
    ]
  end

  def logged_in?
    session[:user_name].present?
  end

  def page_title(extra = 'Little VTES Tournament Helper')
    if @page_title.present?
      @page_title
    else
      "Mylan: #{@page_title_extra.present? ? @page_title_extra : extra}"
    end
  end

  def blank2minus(s)
    s.present? ? s : '-'
  end

  def email_enabled?
    Rails.application.credentials.dig(:email, :enabled)
  end

end
