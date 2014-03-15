class User < ActiveRecord::Base
  # Associations
  has_many :events, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_many :titles, through: :appointments
  belongs_to :rank
  
  has_secure_password
  before_save { email.downcase! }
  before_create :create_remember_token

  # Validations
  validates :name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :password, length: { minimum: 6 }
    
  # Session Token Creation
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  # Checks to see if the User has a title
  def has_title?(title)
    appointments.find_by(title_id: title.id)
  end
  
  # Checks to see if the User has a title with a given name
  def has_title_with_name?(name)
    titles.each do |title|
      if title.name = name
        return true
      end
    end
    return false
  end

  # Adds title to User
  def appoint_title!(title)
    appointments.create!(title_id: title.id)
  end
  
  # Removes title from User
  def unappoint_title!(title)
    appointments.find_by(title_id: title.id).destroy
  end

  # Sets the Users rank
  def setRank!(rank)
    self.update_attribute(:rank_id, rank.id)
    self.reload.rank_id
  end
  
  private
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
      self.rank_id = UserPending
    end
end
