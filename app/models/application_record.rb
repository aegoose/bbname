class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def error_messages
    self.errors.full_messages&.join(',')
  end

end
