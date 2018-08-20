class MenuPolicy < ApplicationPolicy

  protected :index?, :show?, :create?, :new?, :update?, :edit?, :destroy?, :scope

  # alias :menu_admin? :admin?

  public :admin?, :super?, :mayor?, :manager?, :admin_super?

  # class Scope < Scope
  #   def resolve
  #     scope
  #   end
  # end
end
