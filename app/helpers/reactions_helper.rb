module ReactionsHelper
  def status_to_html(status)
    case status
      when 1
        "-"
      when 2
        "!"
      when 3
        "..."
      when 4
        "ok"        
    end
  end


end
