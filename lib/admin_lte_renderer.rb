# Renders an ItemContainer as a <ul> element and its containing items as
# <li> elements.
# It adds the 'selected' class to li element AND the link inside the li
# element that is currently active.
#
# If the sub navigation should be included (based on the level and
# expand_all options), it renders another <ul> containing the sub navigation
# inside the active <li> element.
#
# By default, the renderer sets the item's key as dom_id for the rendered
# <li> element unless the config option <tt>autogenerate_item_ids</tt> is
# set to false.
# The id can also be explicitely specified by setting the id in the
# html-options of the 'item' method in the config/navigation.rb file.

class AdminLteRenderer < SimpleNavigation::Renderer::List

  def render(item_container)
    tag = options[:ordered] ? :ol : :ul
    content = list_content(item_container)
    class_name = item_container.level == 1 ? 'sidebar-menu tree' : 'treeview-menu tree'
    content_tag(tag, content, item_container.dom_attributes.merge(class: class_name))
  end

  protected

  def tag_for(item)
    is_link = !suppress_link?(item)
    has_sub_nav = include_sub_navigation?(item)
    url = is_link ? item.url : 'javascript:void(0)'
    icon_class = item.html_options.delete(:icon_class) || ''
    link_content = content_tag('i', '', class: icon_class) + content_tag('span', item.name)
    link_options = options_for(item)
    link_options.delete(:class)

    if has_sub_nav
      link_content += content_tag('i', '', class: 'fa fa-angle-left pull-right')
    end
    link_to(link_content, url, link_options)
  end

  private

  def list_content(item_container)
    item_container.items&.map { |item|
      li_options = item.html_options.except(:link, :icon_class)
      li_content = tag_for(item)
      if include_sub_navigation?(item)
        li_content << render_sub_navigation_for(item)
        li_options[:class] = (li_options[:class]||'').split(' ').push('treeview').uniq().join(' ')
      end
      content_tag(:li, li_content, li_options)
    }.join
  end
end
