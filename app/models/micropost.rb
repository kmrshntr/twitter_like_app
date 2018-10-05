class Micropost < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :like_users, through: :likes, source: :user
  has_many :comments, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :picture_size
  
  def like(user)
    @like = self.likes.build(user_id: user.id)
    @like.save
  end

  def unlike(user)
    likes.find_by(user_id: user.id).destroy
  end

  def liked?(user)
    like_users.include?(user)
  end
   #contentが無いと作れない
  def comment(content, user)
    @comment = self.comments.build(content: content, user_id: user.id)
  end

  def Micropost.search(search)
    if search
      self.where(['content LIKE ?', "%#{search}%"])
    else
      self.all
    end
  end

  private

  	def picture_size
  		if picture.size > 5.megabytes
  			errors.add(:picture, "should be less than 5MB")
  		end
  	end
end
