class RuneType < ActiveRecord::Base
  # Associations
  has_many :runes  
  
  # Validations
  validates :name, presence: true, length: { maximum: 16 }
  
end
