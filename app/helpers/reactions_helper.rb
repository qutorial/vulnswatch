module ReactionsHelper
  def status_to_integer_index(status)
    retrun nil if status.nil?     
    i = Integer(status.to_s)
    return nil if i.nil?
    if i >= 1 and i <= 5
      return i - 1 
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
    ['-  =unknown', '!  =relevant', '... =in progress', 'ok - not a problem', 'ok - problem fixed']
  end
  
  def reaction_legend()
    'Here is what reaction codes mean: ' +  all_statusses_long().join(', ')
  end
  
  def all_statusses_short()
    ['-', '!', '...', 'ok', 'patched']
  end

  def all_statusses_html()
    all_statusses_short
  end

  def link_to_react(vulnerability)
   reaction = current_user.reactions.find_by(vulnerability_id: vulnerability.id).first
   if reaction.nil?
     return link_to 'react!', new_reaction_path('reaction[vulnerability]' => vulnerability.name)
   else
     return link_to status_to_html(reaction.status), reaction
   end
  end
  

end
