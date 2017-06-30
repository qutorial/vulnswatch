module ReactionsHelper
  def status_to_integer_index(status)
    retrun nil if status.nil?     
    i = Integer(status.to_s)
    return nil if i.nil?
    if i >= 1 and i <= 5
      return i
    end
    return nil
  end
 
  def status_to_html(status)
    i = status_to_integer_index(status)
    return "corrupted" if i.nil?
    return all_statusses_short()[i]
  end

  def status_to_html_long(status)
    i = status_to_integer_index(status)
    return "corrupted status, set it again, please" if i.nil?
    return all_statusses_long()[i]
  end

  def all_statusses()
    all_statusses_long
  end
  
  def all_statusses_long()
    ['-  =unknown', '!  =relevant', '... =in progress', 'ok', 'ok, patched']
  end
  
  def all_statusses_short()
    ['-', '!', '...', 'ok', 'patched']
  end

  def all_statusses_html()
    all_statusses_short
  end
  

end
