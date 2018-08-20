class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    true
  end

  def show?
    # record.blank?
    scope.where(:id => record.id).exists? # 查了遍数据库，有问题
  end

  def create?
    crud?
  end

  def new?
    create?
  end

  def update?
    crud?
  end

  def edit?
    update?
  end

  def destroy?
    crud?
  end

  # 判断角色权限

  def admin?
    @user&.admin?
  end

  def super?
    @user&.super?
  end

  def mayor?
    @user&.mayor?
  end

  def manager?
    @user&.manager?
  end

  def admin_super?
    admin? || super?
  end

  # protected :admin?, :super?, :mayor?, :manager?

  # 可以进行综合管理
  def crud?
    admin?
  end
  protected :crud?

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end

end
