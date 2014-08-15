class Clan < ActiveRecord::Base
  include HTTParty
  
  # Associations
  has_many    :users
  has_many    :applications
  has_many    :videos, dependent: :destroy
  
  # Scopes
  default_scope -> { order('name ASC') }
  
  # Befores
  before_save { clan_email.downcase! }
  
  # Validates
  validates :clan_short_name, presence: true, length: { maximum: 6 }
  validates :name, presence: true, length: { maximum: 256 }
  
  VALID_CLAN_ID_REGEX = /\A[\d]+\z/i
  validates :wot_clanId, presence: true, length: { maximum: 50 }, format: { with: VALID_CLAN_ID_REGEX }
  
  VALID_IMAGE_REGEX = /\A[\w+\-_]+.(jpg|gif|png)\z/i  
  validates :clan_logo, presence: true, format: { with: VALID_IMAGE_REGEX }
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :clan_email, presence: true, format: { with: VALID_EMAIL_REGEX }
  
  # Friendly ID
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  # Methods
  def noreply()
    dc_name = self.name.downcase
    "noreply@#{dc_name.gsub(/\s+/,"")}.net"
  end
  
end
