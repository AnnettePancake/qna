# frozen_string_literal: true
class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Attachment]
    can [:update, :destroy], [Question, Answer, Comment], user: user
    can :destroy, Attachment, attachable: { user: user }

    can :toggle_best, Answer do |answer|
      answer.question.user_id == user.id
    end

    can [:like, :dislike], [Question, Answer] do |voteable|
      voteable.user_id != user.id
    end
  end
end
