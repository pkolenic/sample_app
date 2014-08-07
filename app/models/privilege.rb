class Privilege < ActiveRecord::Base
  # Associations
  has_many :user_privileges, dependent: :destroy
  has_many :users, through: :user_privileges
    
  # validations
  validates :name, presence: true, length: { maximum: 50 }
end
