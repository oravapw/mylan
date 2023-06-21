module ApplicationHelper

  def navtabs
    [
      { label: "Tournaments", path: tournaments_path },
      { label: "Players", path: players_path },
      { label: "Changelog", path: changelogs_path }
    ]
  end

  def logged_in?
    session[:user_name].present?
  end

end
