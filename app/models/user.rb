class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes

  def author_of?(item)
    item.user_id == self.id
  end
  def voted?(post)
    votes.where(user: self, votable: post).exists?
  end
end
