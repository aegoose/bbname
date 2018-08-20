# coding: utf-8
#
module ApiSocialErrors
  include ApiExceptions

  self.class_error_code = 80

  define_wx_error_class 'WxError', -1, '微信处理出错%s'
  define_wx_error_class 'WxAuthorizeFail', 1, '微信授权失败:%s'
  define_wx_error_class 'WxGetUserInfoFail', 1, '微信获取用户信息失败:%s'
end
