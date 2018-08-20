class AdminPolicy < ApplicationPolicy

  def index?
    crud?
  end

  def show?
    crud?
  end

  def lock?
    crud?
  end

  def edit_password?
    crud?
  end

  def crud?
    super?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
