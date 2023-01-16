class User < ApplicationRecord
  has_secure_password
  has_many :requests, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }

  enum role: %i[client admin]
end
