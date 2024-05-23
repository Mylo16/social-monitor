class SocialAccount < ApplicationRecord
  belongs_to :user
  has_many :posts, dependent: :destroy
end
