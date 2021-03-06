class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books,dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments,dependent: :destroy

 has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
 has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

 has_many :followings, through: :relationships, source: :followed
 has_many :followers, through: :reverse_of_relationships, source: :follower



def follow(user_id)
  relationships.create(followed_id: user_id)
end

def unfollow(user_id)
  relationships.find_by(followed_id: user_id).destroy
end

def following?(user)
  followings.include?(user)
end





def favorite_by?(book_id)
 favorites.where(book_id: book_id).exists?
end



  attachment :profile_image


 validates :name, uniqueness: true,presence: true,length: { minimum: 2, maximum: 20}
 validates :introduction,length: { maximum: 50}

end
