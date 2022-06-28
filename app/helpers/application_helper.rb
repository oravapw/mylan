module ApplicationHelper

  def navtabs
    [
      { label: "Overview", path: root_path },
      { label: "Pre-registered", path: registereds_path },
      { label: "Other Players", path: players_path },
      { label: "Tournaments", path: tournaments_path },
      { label: "Changelog", path: changelogs_path }
    ]
  end

  def logged_in?
    session[:logged_in]
  end
end
