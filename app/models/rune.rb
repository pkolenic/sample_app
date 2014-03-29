class Rune < ActiveRecord::Base
  # Associations
  belongs_to :quality
  belongs_to :rune_type
  belongs_to :gear_level
  belongs_to :glyph_prefix  
  
  # Validations
  validates :name, presence: true, length: { maximum: 32 }
  validates :translation, length: { maximum: 32 }  
  validates :level, presence: true, numericality: { greater_than: 0 } 
  validates :rune_type_id, presence: true
  
end
