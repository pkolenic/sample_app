class Quality < ActiveRecord::Base
  # Associations
  has_many :runes
  has_many :aspect_runes  
  
  # Validations
  validates :name, presence: true, length: { maximum: 16 }
  validates :color, presence: true, length: { maximum: 16 }
  
end
