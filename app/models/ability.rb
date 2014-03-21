class Ability
  include CanCan::Ability

  def initialize(user)
    can [:create, :update, :read], Payment, user_id: user.id
    can :manage, User, id: user.id
  end
end
