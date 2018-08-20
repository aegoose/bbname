module Captcha
  class UserLoginFailCounter
    include Singleton

    EXPIRED_TIME = 10.minutes
    FAILED_ATTEMPTS = 1

    def increment(login)
      count = current_count(login) + 1
      cache.write(key_for(login), count, expires_in: EXPIRED_TIME)
      count
    end

    def reset(login)
      cache.delete(key_for(login))
    end

    def show_captcha?(login)
      current_count(login) >= FAILED_ATTEMPTS
    end

    private

    def current_count(login)
      cache.read(key_for(login)) || 0
    end

    def key_for(login)
      "UserLoginFailCount:#{login}"
    end

    def cache
      Rails.cache
    end
  end
end
