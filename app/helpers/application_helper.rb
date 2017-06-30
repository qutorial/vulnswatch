module ApplicationHelper
  def header(text)
    content_for(:header) { text.to_s }
  end
  
  def name_or_nil(object)
    return '' if object.nil?
    return '' if ! object.respond_to?(:name)
    return object.name.to_s
  end

end
