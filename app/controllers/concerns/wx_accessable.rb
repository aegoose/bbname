# frozen_string_literal: true

module WxAccessable
  extend ActiveSupport::Concern

  included do
  end
  # social.xml
  #   wx_pub
  #     app_id
  #     app_secret
  #     host_url
  #     redirect_path
  mattr_reader :wx_pub_app_id, :wx_pub_app_secret, :host_url, :wx_pub_redirect_url, :wx_pub_enabled
  def self.init_wx_pub(app_id, app_secret, host_url, redirect_path, enabled=true)
    if @@wx_pub_app_id.blank? && @@wx_pub_app_secret.blank? && @@host_url.blank?
      @@wx_pub_app_id = app_id
      @@wx_pub_app_secret = app_secret
      @@wx_pub_host = host_url
      @@wx_pub_redirect_url = URI.encode("#{host_url}#{redirect_path}")
      @@wx_pub_enabled = enabled
      # logger.debug "--WxAccessable.init_wx_pub(#{app_id}, #{app_secret}, #{host_url}, #{redirect_path}, #{enabled})"
    end
    return
  end

  protected

  ########################
  # 微信lite url
  def wxlite_jscode2session(app_id, app_secret, authorize_code)
    "https://api.weixin.qq.com/sns/jscode2session?appid=#{app_id}&secret=#{app_secret}&js_code=#{authorize_code}&grant_type=authorization_code"
  end

  ########################
  # 微信的url

  # 授权
  def wx_authorize_url_by_scope(custom_redirect_url = nil, scope = 'snsapi_base')
    redirect_url = custom_redirect_url || wx_pub_redirect_url
    "https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{wx_pub_app_id}&redirect_uri=#{redirect_url}&response_type=code&scope=#{scope}&state=bbname_v1#wechat_redirect"
  end

  # 获取access_token & openid
  def wx_access_token_url_by_code(code)
    "https://api.weixin.qq.com/sns/oauth2/access_token?appid=#{wx_pub_app_id}&secret=#{wx_pub_app_secret}&code=#{code}&grant_type=authorization_code"
  end

  # 获以access_toekn & openid
  def wx_access_token_url_by_refresh(refresh_token)
    "https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=#{wx_pub_app_id}&grant_type=refresh_token&refresh_token=#{refresh_token}"
  end

  # 获取用户信息
  def wx_userinfo_url_by_token_and_openid(access_token, openid)
    "https://api.weixin.qq.com/sns/userinfo?access_token=#{access_token}&openid=#{openid}&lang=zh_CN"
  end


    # 检测请求是否来自微信公众号
  def check_wechat_browser
    # 检查公众号，设置
    render json: {code: 405, message: '请在微信客户端打开链接', data: {}} if request.format.html? && !browser.wechat?
  end

  def wx_pub?
    logger.info("request.fullpath = #{request.url}, wx_pub_enabled = #{wx_pub_enabled}, browser.wechat? = #{browser.wechat?}, request.ssl? = #{request.ssl?}, params[:wx_pub_skip] = #{params[:wx_pub_skip].to_s!='true'}")
    wx_pub_enabled && browser.wechat? && params[:wx_pub_skip] != 'true'
  end

  #######################
  # actions

  # 用户没有登录后，session不存在，并且客户端是微信
  # return true|false 是否跳转
  def before_login_by_wx_pub
    return false unless wx_pub?
    sns_id = cookie_of_sns_id
    if sns_id.present?
      if (adm = Admin.find_by_sns_id(sns_id)).present?
        wxpath = wx_pub_sign_in_and_redirect_to_current_path(adm) # 绑定了相关的账号了，则登录
        logger.debug("--WxAccessable.before_login_by_wx_pub: admin[#{adm.id}] has sns[#{sns_id}], wx_pub_sign_in_and_redirect_to_current_path[#{wxpath}]")
        return true
      end

      # 有可以当前微信的cookie存在，但
      if (sns = SnsAccount.find_by_id(sns_id)).present?
        if sns.valid_refresh_token? # 还在有效期内，直接去绑定账号
          # res = get_wx_pub_access_token_by_refresh(sns.refresh_token)
          # sns = find_or_create_sns_account(res)
          # set_sns_id_cookie(sns.id)
          # 跳转登录页
          wxpath = redirect_to_wx_pub_binding_path
          logger.debug("--WxAccessable.before_login_by_wx_pub: sns[#{sns_id}] exist, redirect_to_wx_pub_binding_path: #{wxpath}")
          return true
        end
      end
    end

    # set_wx_pub_current_url_session # FIXME: 当前url缓存起来
    #组装跳转
    url = URI.encode("#{@@wx_pub_host}/wechat/v1/sign_in")
    auth_path = wx_authorize_url_by_scope(url)
    redirect_to auth_path
    logger.debug("--WxAccessable.before_login_by_wx_pub: sns no binding, wx_authorize_url_by_scope: #{auth_path}")
    return true
  end

  # 微信跳转到的请求
  # return true|false 是否跳转
  def after_login_by_wx_pub(code = nil, redirect_binding = false)
    return false unless wx_pub?

    code = code || params["code"]

    return false if code.blank?

    # 根据微信服务器返回的 code 去拿用户 access_token & openid
    res = get_wx_pub_access_token(code)
    logger.debug("--WxAccessable.after_login_by_wx_pub: get_wx_pub_access_token[#{res&.to_s}]")
    errcode = res['errcode'].to_i
    raise ApiSocialErrors::WxAuthorizeFail.new(res['errmsg']) if errcode > 0
    
    openid = res['openid']
    raise ApiSocialErrors::WxAuthorizeFail.new('no openid found') if openid.blank?

    sns = find_or_create_sns_account(res)
    raise ApiSocialErrors::WxAuthorizeFail.new('invalid params for creating sns_account') if sns.blank?

    # sns_id写到当前的session上
    if (adm = sns.admin).present? && adm.sns_id == sns.id
      wxpath = wx_pub_sign_in_and_redirect_to_current_path(adm)
      logger.debug("--WxAccessable.after_login_by_wx_pub: wx_pub_sign_in_and_redirect_to_current_path[#{wxpath}]")
      return true
    end

    # set_wx_pub_current_url_session # 当前url缓存起来
    set_sns_id_cookie(sns.id) # 缓存当前的sns_id
    if redirect_binding
      wxpath = redirect_to_wx_pub_binding_path
      logger.debug("--WxAccessable.after_login_by_wx_pub: set_sns_id_cookie[#{sns.id}] and redirect_to_wx_pub_binding_path[#{wxpath}]")
      return true
    end
    logger.debug("--WxAccessable.after_login_by_wx_pub: set_sns_id_cookie[#{sns.id}]")
    return false
  end

  # sign_in后，尝试绑定当前sns
  def bind_wx_pub_after_sign_in(adm)
    return unless wx_pub?

    adm_sns_id = adm.sns_id
    sns_id = cookie_of_sns_id
    if sns_id.present? && adm_sns_id != sns_id
      sns = SnsAccount.find_by_id(sns_id)
      if sns.present?
        sns.update_attribute(:admin_id, adm.id) if sns.present? && sns.admin_id != adm.id
        adm.update_attribute(:sns_id, sns_id)
        logger.debug("--WxAccessable.bind_wx_pub_after_sign_in: bind admin[#{adm.id}] with sns[#{sns_id}]")
      end
    end
  end

  # sign_out后，尝试解绑sns
  def unbind_wx_pub_after_sign_out(adm)
    return unless wx_pub?
    return if adm.blank?
    if adm.sns_id.present?
      adm.update_attribute(:sns_id, nil)
      clear_sns_id_cookie
      logger.debug("--WxAccessable.unbind_wx_pub_after_sign_out: unbind admin[#{adm.id}] with sns[#{adm.sns_id}]")
    end
  end

  ############################
  # 辅助

  def find_or_create_sns_account(res)
    token, openid, errcode = res['access_token'], res['openid'], res['errcode'].to_i
    if errcode == 0 && token.present? && openid.present?
      sns = SnsAccount.find_by_openid(openid) || SnsAccount.new(openid: openid)
      sns.access_token = token
      sns.expires_in = res['expires_in']
      sns.refresh_token = res['refresh_token']
      sns.openid = res['openid']
      sns.scope = res['scope']
      sns.authorized_at = Time.now
      save_ok = sns.save
      if !save_ok 
        logger.warn("--WxAccessable.find_or_create_sns_account: save sns[new=#{sns.new_record?}] error: #{sns.error_messages}")
      else
        logger.debug("--WxAccessable.find_or_create_sns_account: save sns[new=#{sns.new_record?}] ok!")
      end
      return sns
    end
    nil
  end

  def redirect_to_wx_pub_binding_path
    # FIXME: 当前的url与登录的url一致，则直接渲染
    # redirect_to new_admin_session_path
    wxpath = wechat_v1_sign_in_path
    redirect_to wxpath
    wxpath
  end

  # 依赖于devise
  def wx_pub_sign_in_and_redirect_to_current_path(adm)
    sign_in(:admin, adm)
    redirect_url = request.env['omniauth.origin'] || stored_location_for(:admin) || backend_root_path
    # redirect_url = session_of_wx_pub_current_url
    # TODO: 清除session的url, 清除cookie的sns_id
    # clear_sns_id_cookie
    # clear_wx_pub_current_url_session
    redirect_to redirect_url
    logger.debug("--WxAccessable.wx_pub_sign_in_and_redirect_to_current_path[#{redirect_url}]")
    redirect_url
  end

  ###############################
  # wechat - api

  # user access token and openid
  def get_wx_pub_access_token(authorize_code)
    url = wx_access_token_url_by_code(authorize_code)
    # {"access_token":"ACCESS_TOKEN", "expires_in":7200, "refresh_token":"REFRESH_TOKEN", "openid":"OPENID", "scope":"SCOPE"  }
    # {"errcode":40029,"errmsg":"invalid code"}
    # logger.debug("--WxAccessable.get_wx_pub_access_token(#{authorize_code}) = #{url}")
    JSON.parse RestClient.get(url).body
  end

  def get_wx_pub_access_token_by_refresh(sns)
    url = wx_access_token_url_by_refresh(sns.refresh_token)
    # {"access_token":"ACCESS_TOKEN", "expires_in":7200, "refresh_token":"REFRESH_TOKEN", "openid":"OPENID", "scope":"SCOPE"  }
    # {"errcode":40029,"errmsg":"invalid code"}
    # logger.debug("--WxAccessable.get_wx_pub_access_token_by_refresh(#{sns.refresh_token}) = #{url}")
    JSON.parse RestClient.get(url).body
  end

  # user info
  def get_wx_pub_user_info(access_token, openid)
    url = wx_userinfo_url_by_token_and_openid(access_token,  openid)
    # {"openid":" OPENID", "nickname": NICKNAME, "sex":"1", "province":"PROVINCE", "city":"CITY", "country":"COUNTRY", "headimgurl": "", "privilege":[ "PRIVILEGE1" "PRIVILEGE2" ],"unionid": "o6_bmasdasdsad6_2sgVt7hMZOPfL"}
    # {"errcode":40003,"errmsg":" invalid openid "}
    # logger.debug("--WxAccessable.get_wx_pub_user_info(#{access_token}, #{openid}) = #{url}")
    JSON.parse RestClient.get(url).body
  end

  #########################
  # cookie and session

  def cookie_of_sns_id
    code = cookies.signed[:bbname_sns_code]
    sns_id = nil
    if code.present?
      # 解码code, 取到sns_id
      arr = Base64.decode64(code)
      snscode, tout = arr.split(":")
      sns_id = (snscode.to_i >> 5)
      # sns_id = nil if expire.to_i < Time.now.to_i
    end
    sns_id
  end

  def set_sns_id_cookie(sns_id)
    expire_at = 2.weeks.from_now
    snscode = (sns_id<<5) + Random.rand(1<<5)
    code = Base64.encode64("#{snscode}:#{expire_at.to_i}").gsub(/\n$/, '')
    cookies.signed[:bbname_sns_code] = {
      value: code,
      expires: expire_at
    }
  end

  def clear_sns_id_cookie
    cookies.delete :bbname_sns_code
  end

  def session_of_wx_pub_current_url
    session['wx_pub_current_url'] || backend_root_path
  end

  def set_wx_pub_current_url_session
    action_skip = (controller_name.in?(["wechats", "sessions"]) && action_name.in?(["binding", "new"])) # 无效的客户端请求
    if !action_skip && request.get? && (request.format.html? || request.format == :wx)
      session['wx_pub_current_url'] = request.fullpath
    end
  end

  def clear_wx_pub_current_url_session
    session.delete 'wx_pub_current_url'
  end
end
