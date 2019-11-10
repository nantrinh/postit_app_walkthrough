class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  
  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: create, length: {minimum: 5}
end
