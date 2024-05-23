class Post < ApplicationRecord
  belongs_to :user
  belongs_to :social_account
  has_many :comments, dependent: :destroy
  has_one :metric, dependent: :destroy
end
