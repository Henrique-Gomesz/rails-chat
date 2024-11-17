class User < ApplicationRecord
  has_secure_password
  has_secure_password :recovery_password, validations: false

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }
  validates :username, presence: true,  uniqueness: true, length: { minimum: 3 }
end
