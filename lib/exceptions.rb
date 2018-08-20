# coding: utf-8

module Exceptions
  class AccessDeny < StandardError
    def code
      1
    end

    def status
      403
    end
  end

  # CODE_SYSTEM = -1 #系统错误
  class CodeSystem < StandardError
    def code
      -1
    end
  end

  # CODE_FORM = 1 #参数错误
  class CodeForm < StandardError
    def code
      1
    end
  end

  # CODE_TOKEN = 2
  class CodeToken < StandardError
    def code
      2
    end
  end

  # CODE_ACCESS_DENY = 4 #不允许访问
  class CodeAccessDeny < StandardError
    def code
      4
    end
  end
end
