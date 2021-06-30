class User < ApplicationRecord
  include Authentication

  validates :name, length: { minimum: 1, maximum: 255 }, presence: true
  validates :email, length: { minimum: 1, maximum: 255 }, presence: true, uniqueness: true
end
