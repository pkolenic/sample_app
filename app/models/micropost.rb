class Micropost < ActiveRecord::Base
  # Associations
  belongs_to :user
  
  # Scoping
  default_scope -> { order('created_at DESC') }
  
  # Validations
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
