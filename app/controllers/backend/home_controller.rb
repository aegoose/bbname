# -*- encoding : utf-8 -*-

module Backend
  class HomeController < Backend::ApplicationController
    # skip_before_action :verify_authenticity_token
    respond_to :html, :json

    layout 'admin_application'

    def index
      add_breadcrumb I18n.t('navs.backend.home_keys'), :backend_root_path
    end

    def tags
      # load_tags
      # respond_modal_with @tags
    end

    def customer_by_tags
    end

    private

  end
end
