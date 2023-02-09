class Employee < ApplicationRecord
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  enum role: {
    guest: 0,
    system_admin: 1,
    admin: 2
  }
end
