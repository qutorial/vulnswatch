module StaticHelper
  def list_people(people)
    people.sort.map(&->p{h(p)}).join('<br>').html_safe
  end
  
  def link_to_genua
    link_to 'genua.de', 'http://genua.de/'
  end
  
  def link_to_github
    link_to 'github', 'https://github.com/qutorial/vulnswatch'
  end

  def link_to_issues(title='Report a Bug', other={})
    other[:target] = '_blank'
    other[:data] = {confirm:
'You will be redirected to github Issues now.
Please, check if there is an issue already.'}
    link_to title, 'https://github.com/qutorial/vulnswatch/issues', other
  end
  
end
