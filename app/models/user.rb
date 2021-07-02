class User < ApplicationRecord
  include Authentication

  has_many :bookings, dependent: :destroy, inverse_of: :user

  validates :name, length: { minimum: 1, maximum: 255 }, presence: true
  validates :email, length: { minimum: 1, maximum: 255 }, presence: true, uniqueness: true
end
