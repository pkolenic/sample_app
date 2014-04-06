class ItemType < ActiveRecord::Base
    # Associations  
  has_many :rune_glyphs
  
  # Validations
  validates :name, presence: true, length: { maximum: 16 }
end
