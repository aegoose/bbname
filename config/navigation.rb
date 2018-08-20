# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  # Specify a custom renderer if needed.
  # The default renderer is SimpleNavigation::Renderer::List which renders HTML lists.
  # The renderer can also be specified as option in the render_navigation call.
  # navigation.renderer = Your::Custom::Renderer

  # Specify the class that will be applied to active navigation items. Defaults to 'selected'
  # navigation.selected_class = 'selected'
  navigation.selected_class = 'active'

  # Specify the class that will be applied to the current leaf of
  # active navigation items. Defaults to 'simple-navigation-active-leaf'
  # navigation.active_leaf_class = 'simple-navigation-active-leaf'
  navigation.active_leaf_class = 'current'

  # Specify if item keys are added to navigation items as id. Defaults to true
  navigation.autogenerate_item_ids = true

  # You can override the default logic that is used to autogenerate the item ids.
  # To do this, define a Proc which takes the key of the current item as argument.
  # The example below would add a prefix to each key.
  # navigation.id_generator = Proc.new {|key| "my-prefix-#{key}"}

  # If you need to add custom html around item names, you can define a proc that
  # will be called with the name you pass in to the navigation.
  # The example below shows how to wrap items spans.
  # navigation.name_generator = Proc.new {|name, item| "<span>#{name}</span>"}

  # Specify if the auto highlight feature is turned on (globally, for the whole navigation). Defaults to true
  # navigation.auto_highlight = true

  # Specifies whether auto highlight should ignore query params and/or anchors when
  # comparing the navigation items with the current URL. Defaults to true
  # navigation.ignore_query_params_on_auto_highlight = true
  # navigation.ignore_anchors_on_auto_highlight = true

  # If this option is set to true, all item names will be considered as safe (passed through html_safe). Defaults to false.
  navigation.consider_item_names_as_safe = false

  # Define the primary navigation
  navigation.items do |primary|
    # Add an item to the primary navigation. The following params apply:
    # key - a symbol which uniquely defines your navigation item in the scope of the primary_navigation
    # name - will be displayed in the rendered navigation. This can also be a call to your I18n-framework.
    # url - the address that the generated item links to. You can also use url_helpers (named routes, restful routes helper, url_for etc.)
    # options - can be used to specify attributes that will be included in the rendered navigation item (e.g. id, class etc.)
    #           some special options that can be set:
    #           :if - Specifies a proc to call to determine if the item should
    #                 be rendered (e.g. <tt>if: -> { current_user.admin? }</tt>). The
    #                 proc should evaluate to a true or false value and is evaluated in the context of the view.
    #           :unless - Specifies a proc to call to determine if the item should not
    #                     be rendered (e.g. <tt>unless: -> { current_user.admin? }</tt>). The
    #                     proc should evaluate to a true or false value and is evaluated in the context of the view.
    #           :method - Specifies the http-method for the generated link - default is :get.
    #           :highlights_on - if autohighlighting is turned off and/or you want to explicitly specify
    #                            when the item should be highlighted, you can set a regexp which is matched
    #                            against the current URI.  You may also use a proc, or the symbol <tt>:subpath</tt>.

    # You can also specify a condition-proc that needs to be fullfilled to display an item.
    # Conditions are part of the options. They are evaluated in the context of the views,
    # thus you can use all the methods and vars you have available in the views.
    primary.item :customers, I18n.t('navs.backend.home_keys'), backend_root_path, html: { icon_class: 'fa fa-home' }

    # primary.item :businesses, I18n.t('navs.backend.businesses'), 'javascript:void(0)', html: { icon_class: 'fa fa-bars' }, class: 'menu-open' do |snav|
      # snav.item :customers, I18n.t('navs.backend.customers'), backend_customers_path, html: { icon_class: 'fa fa-users' }
      # snav.item :customer_products, I18n.t('navs.backend.customer_products'), backend_customer_products_path, html: { icon_class: 'fa fa-shopping-cart' }
      # snav.item :financial_products, I18n.t('navs.backend.financial_products'), backend_financial_products_path, highlights_on: :subpath, html: { icon_class: 'fa fa-gg' }
      # snav.item :bank_cards, I18n.t('navs.backend.bank_cards'), backend_bank_cards_path, highlights_on: :subpath, html: { icon_class: 'fa fa-credit-card' }
      # snav.item :imports, I18n.t('navs.backend.imports'), backend_imports_path, html: { icon_class: 'fa fa-upload' } if policy(:menu).manager? or policy(:menu).super? || policy(:menu).admin?
    # end

    primary.item :system, I18n.t('navs.backend.systems'), 'javascript:void(0)', html: { icon_class: 'fa fa-cog' }, class: 'menu-open' do |snav|
      # Add an item to the sub navigation (same params again)

      snav.item :admins, I18n.t('navs.backend.admins'), backend_admins_path, highlights_on: :subpath, html: { icon_class: 'fa fa-user-o' } if policy(:menu).super?
      snav.item :areas, I18n.t('navs.backend.areas'), backend_areas_path, highlights_on: :subpath, html: { icon_class: 'fa fa-globe' } if policy(:menu).super?
      # snav.item :branches, I18n.t('navs.backend.branches'), backend_branches_path, highlights_on: :subpath, html: { icon_class: 'fa fa-sitemap' } if policy(:menu).super?
      # snav.item :admin_logs, I18n.t('navs.backend.admin_logs'), backend_admin_logs_path, html: { icon_class: 'fa fa-history' } if policy(:menu).super?

      # snav.item :catgs, I18n.t('navs.backend.catgs'), backend_catgs_path, highlights_on: :subpath, html: { icon_class: 'fa fa-th' }
      # snav.item :tag_keys, I18n.t('navs.backend.tag_keys'), backend_tag_keys_path, highlights_on: :subpath, html: { icon_class: 'fa fa-server' } if policy(:menu).super?
    end if policy(:menu).super?

    # you can also specify html attributes to attach to this particular level
    # works for all levels of the menu
    # primary.dom_attributes = {id: 'menu-id', class: 'menu-class' }

    # You can turn off auto highlighting for a specific level
    # primary.auto_highlight = false
    primary.dom_attributes = { id: 'adminMenu', class: 'tree', 'data-widget': 'tree', 'data-accordion': false }
  end
end
