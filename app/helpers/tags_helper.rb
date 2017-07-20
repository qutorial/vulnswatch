module TagsHelper
  def link_to_tag(vulnerability, other={})
    link_to ' + Add Tag', new_tag_path('tag[vulnerability]' => vulnerability.name), other
  end

  def link_to_delete_tag(tag, title='Delete', other={})
    other[:method] = :delete
    other[:data] = { confirm: "Un-tag #{tag.vulnerability.name} with #{tag.component}?" }
    link_to title, tag, other
  end
end
