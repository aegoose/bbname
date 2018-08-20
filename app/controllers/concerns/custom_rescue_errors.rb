# rescue errors
module CustomRescueErrors
  extend ActiveSupport::Concern

  included do
    rescue_json_errors
    rescue_errors unless Rails.env.development?
  end

  def render_error_base(exception = nil, code = 1, status = 500)
    @_exception = exception
    code = exception.try(:code) || code
    status = exception.try(:status) || status
    custom_log(exception, status, code)
    if request.xhr? || request.format && (request.format.js? || request.format.json?) || request.path_info.start_with?('/api')
      render json: { code: code, errmsg: exception&.message, message: exception&.message }, status: status
    else
      tpl = template_exists?("/errors/#{status}") ? "/errors/#{status}" : '/errors/404'
      render template: tpl, formats: [:html], layout: 'errors'
    end
  end
  private :render_error_base

  def user_not_authorized(exception = nil)
    render_error_base(exception, 13, 403)
  end

  def render_not_found(exception = nil)
    render_error_base(exception, 14, 404)
  end

  def render_error(exception = nil)
    render_error_base(exception, 15, 500)
  end

  def render_api_error(e)
    code = e.try(:code) || 1
    status = e.try(:status) || 500
    message = e.try(:message)
    custom_log(e, status, code)

    res = { code: code, message: message, status: status }.compact
    render json: res
  end

  module ClassMethods
    def rescue_json_errors
      rescue_from ApiExceptions::BaseException, with: :render_api_error
    end
    def rescue_errors
      rescue_from Exception, with: :render_error
      rescue_from RuntimeError, with: :render_error
      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
      rescue_from ActionController::RoutingError, with: :render_not_found
      rescue_from ActionController::UnknownController, with: :render_not_found
    end
  end
end
