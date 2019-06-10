class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  has_many :microposts, dependent: :destroy
  scope :order_by_name, ->(name){order(id: name)}

  before_save :downcase_email
  before_create :create_activation_digest
  before_save { email.downcase! }

  validates :name, presence: true, length: { maximum: Settings.validates.name.lenght }
  VALID_EMAIL_REGEX = Settings.validates.email.regex
  validates :email, presence: true, length: { maximum: Settings.validates.email.lenght }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: Settings.validates.password.lenght.minimum }, allow_nil: true

  has_secure_password

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)

  end

  def forget
    update remember_token: nil
  end

  def activate
    update_attribute :activated, true
    update_attribute :activated_at, Time.zone.now

  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update reset_digest:  User.digest(reset_token)
    update reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < Settings.password_reset_expired.hours.ago
  end

  def feed
    Micropost.where "user_id = ?", id
  end

  private

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
