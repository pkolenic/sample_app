class EssenceRune < ActiveRecord::Base
  # Associations
  has_many   :rune_glyphs
  
  # Validations
  validates :name, presence: true, length: { maximum: 32 }
  validates :translation, length: { maximum: 32 }
end
