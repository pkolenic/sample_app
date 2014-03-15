class Rank < ActiveRecord::Base
  # Associations
  has_many :users  
  
  # Validations
  validates :title, presence: true, length: { maximum: 50 }
  
end
