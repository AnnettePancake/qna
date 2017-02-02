class Authorization < ApplicationRecord
  belongs_to :user, optional: true

  validates :provider, :uid, presence: true
  validates :provider, uniqueness: { scope: :uid }
end
