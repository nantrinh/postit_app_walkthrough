class Comment < ActiveRecord::Base
  belongs_to :creator, class_name: "User", foreign_key: "user_id"
  belongs_to :post
  has_many :votes, as: :voteable

  validates :body, presence: true

  def total_votes
    self.upvotes - self.downvotes  
  end
  
  def upvotes
    self.votes.where(vote: true).size
  end
  
  def downvotes
    self.votes.where(vote: false).size
  end
end
