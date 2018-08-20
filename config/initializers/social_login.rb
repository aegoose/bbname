cf_wxpub = Rails.application.config_for(:social_login)['wx_pub']

ActiveSupport::Reloader.to_prepare do
    WxAccessable.init_wx_pub(cf_wxpub['app_id'], cf_wxpub['app_secret'], cf_wxpub['host_url'], cf_wxpub['redirect_path'], cf_wxpub['enabled'])
    # WxAccessable.setup do|cf|
    # cf.wx_pub_config = cf_wxpub
    # cf.reset_wx_pub
    # end
end