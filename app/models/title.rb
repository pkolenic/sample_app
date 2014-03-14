class Title < ActiveRecord::Base
  # Associations
  has_many :appointments, dependent: :destroy
  has_many :users, through: :appointments
    
  # validations
  validates :name, presence: true, length: { maximum: 50 }
end
