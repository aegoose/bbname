# rescue errors
module AuthorizeAccessable
  extend ActiveSupport::Concern

  included do
    include Pundit
    rescue_from Pundit::NotAuthorizedError, with: :pundit_user_not_authorized

    # def user_not_authorized
    #   flash[:alert] = "You are not authorized to perform this action."
    #   redirect_to(request.referrer || root_path)
    # end

    def pundit_user_not_authorized(exception = nil)

      policy_name = exception.policy.class.to_s.underscore

      logger.info "-----policy:#{policy_name}, query:#{exception&.query}: error:#{exception&.message}"

      if respond_to?(:user_not_authorized)
        user_not_authorized Pundit::NotAuthorizedError.new(t('pundit.default'))
        return
      end

      if session['user_referer_url'] && request.fullpath != session['user_referer_url']
        redirect_to session['user_referer_url']
      else
        redirect_to root_path
      end
    end
    private :pundit_user_not_authorized

    def pundit_user
      current_admin
    end

  end

end
