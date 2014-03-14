class Appointment < ActiveRecord::Base
  # Associations
  belongs_to :user
  belongs_to :title
  
  # Validations
  validates :user_id, presence: true
  validates :title_id, presence: true
end
