module Captcha #:nodoc
  module Helper #:nodoc

    include SimpleCaptcha::ControllerHelpers

    protected

    def captcha_require?(key)
      UserLoginFailCounter.instance.show_captcha?key
    end
    def clear_captcha_require(key)
      UserLoginFailCounter.instance.reset(key)
    end

    # protected
    #
    # MAX_FAILED_TIMES = 5
    #
    # def check_if_captcha_required(captcha_subject, max_failed_times = MAX_FAILED_TIMES)
    #   session[key_for_failed_times(captcha_subject)] = (session[key_for_failed_times(captcha_subject)] || 0) + 1
    #   session[key_for_require_flag(captcha_subject)] = session[key_for_failed_times(captcha_subject)] >= max_failed_times
    # end
    #
    # def clear_captcha_require(captcha_subject)
    #   session.delete(key_for_failed_times(captcha_subject))
    #   session.delete(key_for_require_flag(captcha_subject))
    # end
    #
    # def captcha_require?(captcha_subject)
    #   session[key_for_require_flag(captcha_subject)]
    # end
    #
    # private
    # def key_for_failed_times(captcha_subject)
    #   [captcha_subject, :failed_times].join('_')
    # end
    #
    # def key_for_require_flag(captcha_subject)
    #   [captcha_subject, :require_captcha_flag].join('_')
    # end
  end
end
