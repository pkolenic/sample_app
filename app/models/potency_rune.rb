class PotencyRune < ActiveRecord::Base
  # Associations
  belongs_to :gear_level
  belongs_to :glyph_prefix
  has_many   :rune_glyphs

  # Validations
  validates :name, presence: true, length: { maximum: 32 }
  validates :translation, length: { maximum: 32 }  
  validates :level, presence: true, numericality: { greater_than: 0 } 
end
