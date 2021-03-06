module ApplicationHelper
  def bootstrap_class_for flash_type
    { success: "alert-success",
      error: "alert-danger",
      alert: "alert-warning",
      warning: "alert-warning",
      notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
  end
  
  def pretty_time(time) 
    time.strftime "%b %d %Y"
  end 

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} fade in") do
              concat content_tag(:i, '', class: "fa fa-times close", data: { dismiss: 'alert' })
              concat message
            end)
    end
    nil
  end

  def avatar_url_for(user, size = 50, title = user.name)
    user.avatar_url || gravatar_image_url(user.email, size: size)
  end

  def search_options
    s = ''

    s << "<optgroup label=\"#{t("search_category_group")}\">"
    Category.all.each do |category|
      s << "<option value='#{category.id}'>#{category.display_name}</option>"
    end
    s << "</optgroup>"

    s << "<optgroup label=\"#{t("search_location_group")}\">"
    LOCATION_LIST.each do |location|
      name = I18n.locale == :en ? location[:displayNameEN] : location[:displayName]
      s << "<option value='#{location[:id]}'>#{name}</option>"
    end
    s << "</optgroup>"

    s.html_safe
  end

  def location_options
    location_arr = []
    LOCATION_LIST.each do |location|
      name = I18n.locale == :en ? location[:displayNameEN] : location[:displayName]
      location_arr << [ name, location[:id] ]
    end
    location_arr
  end

  def location_name(location_id)
    location = LOCATION_LIST.find { |e| e[:id] == location_id }

    return '' if location.nil?
    I18n.locale == :en ? location[:displayNameEN] : location[:displayName]
  end

end
