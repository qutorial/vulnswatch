module ReactionsHelper
  def status_to_integer_index(status)
    return nil if status.nil?     
    i = Integer(status.to_s)
    return nil if i.nil?
    if i >= 1 and i <= 4
      return i - 1 
    end
    return nil
  end
 
  def status_to_html_long(status)
    i = status_to_integer_index(status)
    return "corrupted status, set it again, please" if i.nil?
    return all_explanations()[i]
  end
  
  def status_to_link_class(status)
    i = status
    return 'status_link no_reaction' if i.nil? or i == 0
    i = status_to_integer_index(status)
    return 'status_link ' + all_statusses_names()[i]
  end

  def all_statusses()
    all_explanations()
  end
  
  def all_explanations()
    ['no reaction', 'relevant', 'work in progress', 'ok - not a problem', 'ok - problem fixed']
  end

  def all_explanations_short()
    ['no reaction','relevant', 'in progress', 'not a problem', 'problem fixed']
  end

  def explanations_collection_short()
    (0..4).map(&->(status){ [all_explanations_short[status], status+1] } )
  end

  def all_statusses_names()
    ['relevant', 'in_progress', 'ok', 'fixed']
  end
  
  def reaction_legend()
    legend = 'Reaction codes: ' + 
       (0..4).map(&->(status){ (link_to '', '', class: status_to_link_class(status)) + ' - ' + all_explanations_short()[status] }).join('  ')
    return legend   
  end
  
  def all_statusses_html()
    all_statusses_short
  end

  def link_to_react(vulnerability)
   reaction = nil
   
   vulnerability.reactions.each do |r| 
     reaction = r if r.user_id == current_user.id 
   end 
   
   if reaction.nil?
     return link_to '', new_reaction_path('reaction[vulnerability]' => vulnerability.name), class: status_to_link_class(nil), title: 'Click to react on it'
   else
     return link_to '', edit_reaction_path(reaction), class: status_to_link_class(reaction.status), title: reaction.user.name + ': ' + reaction.text
   end
  end
  

end
