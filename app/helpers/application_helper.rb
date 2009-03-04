module ApplicationHelper
  
  def title(str, container = nil)
    @page_title = str
    content_tag(container, str) if container
  end
  
  def icon(name, extension="png")
    image_tag("icons/#{name}.#{extension}",:class => "icon")
  end
  
  
end
