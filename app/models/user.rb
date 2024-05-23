class User < ApplicationRecord
  has_secure_password
  has_many :social_accounts, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :comments, through: :posts
end
