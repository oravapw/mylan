module ApplicationHelper
  def navtabs
    [
      { label: "Overview", path: root_path },
      { label: "Pre-registered", path: registereds_path },
    ]
  end
end
