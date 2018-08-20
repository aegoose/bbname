# coding: utf-8
module ApiExceptions
  extend ActiveSupport::Concern
  included do
    # 定义 类的返回码, 默认为 '00'
    # 约定只定义两位整数, eg. 11, 12, 99
    mattr_accessor :class_error_code
  end

  class BaseException < StandardError; end
  class BaseWxException < BaseException; end

  class_methods do
    def define_wx_error_class(error_class, error_code, error_message = '', return_status = nil)
      define_error_class_by_symbol(error_class, error_code, error_message, ApiExceptions::BaseWxException, return_status )
    end
    def define_error_class(error_class, error_code, error_message = '', return_status = nil)
      define_error_class_by_symbol(error_class, error_code, error_message, ApiExceptions::BaseException, return_status )
    end

    def define_error_class_by_symbol(error_class, error_code, error_message = '', base_class, return_status)
      raise "class: #{error_class} already defined!" if const_defined?(error_class)
      parent = self

      klass = Class.new base_class do
        def initialize(*msg_args)
          @msg_args = msg_args || []
        end

        # 错误类整体输出的错误码为: error_code + class_error_code
        define_method :code do
          "#{error_code}#{parent.class_error_code || '00'}".to_i
        end

        define_method :message do
          # error_message maybe a format string
          emsg = error_message.to_s
          emsg = emsg.gsub(/(\%s)$/, ': \1') if emsg.end_with?('%s') && !@msg_args.blank?
          emsg % @msg_args
        end

        define_method :status do
          return_status
        end
      end

      const_set error_class, klass
      nil
    end
  end
end
