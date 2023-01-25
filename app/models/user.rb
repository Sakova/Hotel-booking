# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string
#  name            :string
#  password_digest :string
#  role            :integer          default("client"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  has_secure_password
  has_many :requests, dependent: :destroy
  has_many :bills, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }

  enum role: %i[client admin]
end
