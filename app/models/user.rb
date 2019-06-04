class User < ApplicationRecord
  has_many :microposts
  before_save { email.downcase! }
  validates :name, presence: true, length: { maximum: Settings.validates.name.lenght }
  VALID_EMAIL_REGEX = Settings.validates.email.regex
  validates :email, presence: true, length: { maximum: Settings.validates.email.lenght },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: Settings.validates.password.lenght.minimum }
  validates :password_confirmation, presence: true, length: { minimum: Settings.validates.password.lenght.minimum }

  has_secure_password
end
