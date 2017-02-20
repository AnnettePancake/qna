# frozen_string_literal: true
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable,
         omniauth_providers: [:facebook, :twitter]

  has_many :questions
  has_many :answers
  has_many :votes
  has_many :comments
  has_many :authorizations
  has_many :subscriptions, dependent: :destroy

  after_save ThinkingSphinx::RealTime.callback_for(:user)

  def self.find_for_oauth(auth)
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return authorization.user if authorization

    email = auth.info[:email]

    user = User.find_by(email: email) || User.generate_user(email)
    user.create_authorization(auth)
    user
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid, confirmed: true)
  end

  def self.generate_user(email)
    password = Devise.friendly_token[0, 20]
    User.create!(email: email, password: password, password_confirmation: password)
  end
end
