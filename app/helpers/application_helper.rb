module ApplicationHelper
  def encode_url(url)
    ERB::Util.url_encode(url)
  end

  def active_page?(path='')
    request.path_info == path
  end

  def append_class_on_path(tag, attrs, name, path, css_class)
    haml_tag(tag, name, attrs.merge!(class: (css_class if active_page?(path))))
  end

  def link_to_active_page(name, path, css_class='active')
    append_class_on_path :a, {:href => path}, name, path, css_class
  end

  def page
    if params[:page].nil? then
      1
    else
      params[:page].to_i
    end
  end

end
