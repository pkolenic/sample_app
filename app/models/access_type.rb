class AccessType < ActiveRecord::Base
  # Associations
  has_many    :videos
  
  # Validations
  validates :name, presence: true, length: { maximum: 50 }
end
