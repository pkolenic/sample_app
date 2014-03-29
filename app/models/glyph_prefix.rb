class GlyphPrefix < ActiveRecord::Base
  # Associations
  has_many :potency_runes  
  has_many :runes
  
  # Validations
  validates :name, presence: true, length: { maximum: 16 }  
end
