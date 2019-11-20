module ApplicationHelper
  def fix_url(str)
    str.start_with?('http://', 'https://') ? str : "http://#{str}"
  end

  def display_datetime(dt)
    dt.strftime("%m/%d/%Y %l:%M%P %Z")
  end

  def restrict_newlines(text, n)
    text.count("\n") > n ? text.split("\n")[0..n].join("\n") + "..." : text
  end
end
