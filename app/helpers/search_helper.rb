module SearchHelper

  def order_check_box(order_option, name, current_order)
    is_current = current_order == order_option
    klass = is_current ? "highlightoption" : ""
    control_id = order_option
    output = capture_haml do
      haml_concat(label_tag("sort_order_#{control_id}", name, :class=> klass, :onclick=>'highlightlabel(this)'))
      haml_concat(radio_button_tag(:sort_order, control_id, is_current, :class=>'sort_radio'))
    end
    output
  end

  def build_onSearch_message(form_model)
    show_message_onSearch= ""
    if @investigations_count == 1
      show_message_onSearch += "#{@investigations_count}  <a href='javascript:void(0)' onclick='window.scrollTo(0,$(\"investigations_bookmark\").offsetTop)'>#{t(:investigation)}</a>"
    elsif @investigations_count > 0
      show_message_onSearch += "#{@investigations_count}  <a href='javascript:void(0)' onclick='window.scrollTo(0,$(\"investigations_bookmark\").offsetTop)''>#{t(:investigation).pluralize}</a>"
    end

    if @activities_count > 0 && @investigations_count > 0
      show_message_onSearch += ","
    end
    if @activities_count == 1
      show_message_onSearch += " #{@activities_count} <a href='javascript:void(0)' onclick='window.scrollTo(0,$(\"activities_bookmark\").offsetTop)'>activity</a>"
    elsif @activities_count > 0
      show_message_onSearch += " #{@activities_count} <a href='javascript:void(0)' onclick='window.scrollTo(0,$(\"activities_bookmark\").offsetTop)'>activities</a>"
    end

    show_message_onSearch +=" matching"
    if (form_model && form_model.text)
      show_message_onSearch +=" search term \"#{form_model.text}\" and"
    end
    show_message_onSearch +=" selected criteria"
  end

  def show_material_icon(material, link_url, hide_details)
    if material.material_type == "Investigation"
      icon_url = material.icon_image
    elsif material.material_type == "Activity"
      icon_url = material.icon_image
    end
    output = capture_haml do
      haml_tag :div, :class => "material_icon" do
			  unless icon_url.blank?
					unless link_url.nil?
          	haml_tag :a, :href => link_url, :class => "thumb_link" do
            	unless icon_url.blank?
              	haml_tag :img, :src => icon_url, :width=>"100%"
            	end
          	end
				  else
            haml_tag :img, :src => icon_url, :width=>"100%"
          end
        end
      end
    end
    return output
  end

  def assign_material_link(material, action, extra={})
    if current_user && current_user.portal_teacher
      link_to("Assign to a Class", action, extra.merge({:class=>"button"}))
    end
  end

end
