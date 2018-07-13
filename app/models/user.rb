class User < ApplicationRecord
  attr_accessor :remember_token
  before_save{self.email = email.downcase}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, length: {maximum: Settings.name_max}
  validates :email, presence: true, length: {maximum: Settings.email_max},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, length: {minimum: Settings.pass_min}

  class << self
    def digest string
      cost =
        if ActiveModel::SecurePassword.min_cost
          BCrypt::Engine::MIN_COST
        else
          BCrypt::Engine.cost
        end
      BCrypt::Password.create(string, cost: cost)
    end
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end
end
