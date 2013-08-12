class User < ActiveRecord::Base
  has_secure_password
  before_save { email.downcase! }
  before_create :create_remember_token
  before_create :set_pending_status

  # Validations
  validates :name, presence: true, length: { maximum: 50 }
  validates :wot_name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :password, length: { minimum: 6 }
  
  # User Role Checks
  def pending_approval?
    self.role == UserPending
  end
  
  def active_member?
    self.role > UserPending
  end

  def can_approve?
    self.role >= UserRecruiter
  end
  
 def can_promote?(user)
    case self.role
    when UserCompanyCommander
      case user.role
      when UserRecruit
        true
      when UserSoldier
        true
      else
        false
      end
    when UserFieldCommander
      case user.role
      when UserRecruit
        true
      when UserSoldier
        true
      when UserCompanyCommander
        true
      else
        false
      end
    when UserDeputyCommander
      case user.role
      when UserRecruit
        true
      when UserSoldier
        true
      when UserTreasurer
        true
      when UserRecruiter
        true
      when UserDiplomat
        true
      when UserCompanyCommander
        true
      when UserFieldCommander
        true
      else
        false
      end
    when UserCommander
      case user.role
      when UserRecruit
        true
      when UserSoldier
        true
      when UserTreasurer
        true
      when UserRecruiter
        true
      when UserDiplomat
        true
      when UserCompanyCommander
        true
      when UserFieldCommander
        true
      when UserDeputyCommander
        true
      else
        false
      end
    when UserSuper
      case user.role
      when UserPending
        false
      else
        true
      end
    else
      false
    end
  end
  
  # Session Token Creation
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
    def set_pending_status
      self.role = UserPending
    end
end
