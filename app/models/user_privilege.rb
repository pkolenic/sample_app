class UserPrivilege < ActiveRecord::Base
  # Associations
  belongs_to :user
  belongs_to :privilege
  
  # Validations
  validates :user_id, presence: true
  validates :privilege_id, presence: true
end
