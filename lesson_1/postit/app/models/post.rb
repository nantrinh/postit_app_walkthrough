class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :post_categories, dependent: :destroy
  has_many :categories, through: :post_categories
end
