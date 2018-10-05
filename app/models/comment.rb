class Comment < ApplicationRecord
	validates :content, presence: true, length: { maximum: 140 }
	validates :user_id, presence: true
	validates :micropost_id, presence: true
	default_scope -> { order(created_at: :desc) }
	belongs_to :user
	belongs_to :micropost
end
