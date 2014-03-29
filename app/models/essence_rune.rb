class EssenceRune < ActiveRecord::Base

  # Validations
  validates :name, presence: true, length: { maximum: 32 }
  validates :translation, length: { maximum: 32 }
end
