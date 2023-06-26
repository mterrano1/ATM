class User < ApplicationRecord
  has_one :account

  has_secure_password

  validates :username, :first_name, :last_name, :email, presence: true
  validates :username, uniqueness: true
end