class Employee < ApplicationRecord
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable, authentication_keys: [:login]

  enum role: {
    guest: 0,
    system_admin: 1,
    admin: 2
  }

  attr_writer :login

  def login
    @login || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where(["lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end
end
