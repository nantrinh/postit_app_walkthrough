class Comment < ActiveRecord::Base
  belongs_to :creator, class_name: "User", foreign_key: "user_id"
  belongs_to :post
  has_many :votes, as: :voteable

  validates :body, presence: true
end
