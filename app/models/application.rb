class Application < ActiveRecord::Base
  # Associations
  belongs_to :user
  belongs_to :clan
  
  # Validations
  validates :user_id, presence: true
  validates :clan_id, presence: true
end
