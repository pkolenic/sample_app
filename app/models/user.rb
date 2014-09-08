class User < ActiveRecord::Base
  include HTTParty  
  
  has_secure_password
  before_save { email.downcase! }
  before_create :create_remember_token
  after_create :lookup_wot_id

  # Associations
  has_many :tournaments, dependent: :destroy
  belongs_to  :clan
  has_one     :application
  has_many :user_privileges, dependent: :destroy
  has_many :privileges, through: :user_privileges

  # Validation Classes
  class WotNameValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      if (!value.nil?)
        if record.id.nil?
          existing_user = User.find_by(name: record.name)
          record.errors['World'] << 'of Tanks Name already in use' if existing_user && existing_user.active?
        end
      end
    end
  end
  
  class OptionalValueValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      if (!value.nil?)
        if (value < 1)
          record.errors[attribute] << 'must be blank or greater than 0'
        end
      end
    end
  end 

  # Validations
  validates :name, presence: true, length: { maximum: 50 }, wotName: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :password, length: { minimum: 6 }
  validates :clan_id, optional_value: true 
  
  def forem_name
    name
  end   
  
  # Checks to see if the User has a privilege
  def has_privilege?(privilege)
    user_privileges.find_by(privilege_id: privilege)
  end  
  
  # Checks to see if the User has a privilege with a given name
  def has_privilege_with_name?(name)
    privileges.each do |privilege|
      if privilege.name = name
        return true
      end
    end
    return false
  end  
  
  # Friendly ID
  extend FriendlyId
  friendly_id :name, use: :slugged

  # User Role Checks
  def clanwar_member?
    self.clan_war_team
  end
  
  def pending_approval?
    self.role == UserPending
  end
  
  def active_member?
    self.role > UserPending
  end

  def can_approve?
    self.role >= UserRecruiter
  end
  
  def can_appoint_clanwar?(user)
    if self.role >= UserDeputyCommander && user.clan && user.clan == self.clan
      return true
    else
      return false
    end
  end
  
  def hasPrivilege?(name)
    self.privileges.include?(Privilege.find_by(name: name))
  end
  
  # Session Token Creation
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

 def update_stats
    if !Rails.env.test?
      if self.wot_id.blank?
        request_wot_id
      end
      
      if self.wot_id          
        updateCoreStats()
        updateClan()       
        clearApplications()       
        self.slug = self.name.parameterize                       
        self.save validate: false
      end            
    end    
  end

  private
    def updateCoreStats()
      url = "https://api.worldoftanks.com/wot/account/info/?application_id=#{ENV['WOT_API_KEY']}&account_id=#{self.wot_id}"     
      json_response = clean_response(self.class.get url)
      
      if json_response["status"] == 'ok'
        data = json_response["data"]["#{self.wot_id}"]
        if !data.blank? 
          # Last Online
          self.last_online = DateTime.strptime("#{data['last_battle_time']}", '%s')
          
          # Total Stats
          if data["statistics"]
            #Rails.logger.info "Updating Statistics For #{self.name}"
            self.battles_count = data["statistics"]["all"]["battles"]
            self.wins = data["statistics"]["all"]["wins"]
            self.losses = data["statistics"]["all"]["losses"] 
            self.survived = data["statistics"]["all"]["survived_battles"]
            self.experiance = data["statistics"]["all"]["xp"]
            self.max_experiance = data["statistics"]["max_xp"]
            self.spotted = data["statistics"]["all"]["spotted"]
            self.frags = data["statistics"]["all"]["frags"]
            self.damage_dealt = data["statistics"]["all"]["damage_dealt"]
            self.hit_percentage = data["statistics"]["all"]["hits_percents"]
            self.capture_points = data["statistics"]["all"]["capture_points"]
            self.defense_points = data["statistics"]["all"]["dropped_capture_points"]
            # self.avg_tier = calculate_avg_tier(total["vehicles"])
          end                    
        end
      end
    end
    
    def updateClan()
      url = "https://api.worldoftanks.com/wot/clan/membersinfo/?application_id=#{ENV['WOT_API_KEY']}&member_id=#{self.wot_id}"
      json_response = clean_response(self.class.get url)
      
      if json_response["status"] == 'ok'
        data = json_response["data"]["#{self.wot_id}"]
        if !data.blank?          
          # Clan Details      
          update_clan(data["clan_id"], data["role"])
        else
          check_ambassador()           
        end
      end
    end
  
    def clearApplications()
      if self.clan_id
        Application.where("clan_id = #{self.clan_id} AND user_id = ?", self.id).each do |application|
          application.destroy
        end
      end
    end
  
    def calculate_avg_tier(tanks)
      total_tiers = 0
      battle_count = 0
      tanks.each do |tank|
        total_tiers += (tank['level'] * tank['battle_count'])
        battle_count += tank['battle_count']
      end
      avg_tier = (total_tiers.to_f / battle_count) 
    end
  
    def calculate_win7(avg_tier, frags, avg_damage, avg_spot, avg_def, win_rate, games_played)
      win7 = ((1240-1040/([tier,6].min)**0.164)*frags)
      win7 += (avg_damage*530/(184*Math::E^(0.24*avg_tier)+130))
      win7 += (avg_spot*125*[avg_tier, 3].min/3)
      win7 += ([avg_def, 2.2].min * 100)
      win7 += (((185/(0.17+Math::E^((win_rate-35)*-0.134)))-500)*0.45)
      win7 -= ((5 - [avg_tier, 5].min * 125) / (1 + Math::E**(( avg_tier - (games_played/220)**(3/avg_tier) )*1.5)))       
    end
  
    def check_ambassador
      # Check if was in clan first
      if self.clan_id || self.role == UserAmbassador
        self.role = UserAmbassador              
      end
      self.clan_id = nil       
    end
    
    def update_clan(clan_id, role)   
      # Lookup the clan 
      clan = Clan.find_by(wot_clanId: "#{clan_id}")      
      if clan
        self.clan_id = clan.id        
        if self.active?
          previous_role = self.role
          self.role = convert_role(role)          
          if previous_role != self.role       
            if self.role > previous_role && self.active?
              UserMailer.promoted(self, user_role(self.role), '').deliver
            elsif self.active?
              UserMailer.demoted(self, user_role(self.role), 'Auto Sent based on action taken on the Official World of Tank Clan page.').deliver
            end            
          end
        end
      else
        check_ambassador()
      end
    end
  
   def convert_role(role)
      case role
      when 'recruit'
        role_id = UserRecruit
      when 'private'
        role_id = UserSoldier
      when 'treasurer'
        role_id =UserTreasurer
      when 'recruiter'
        role_id = UserRecruiter
      when 'diplomat'
        role_id = UserDiplomat
      when 'commander'
        role_id= UserCompanyCommander
      when 'vice_leader'
        role_id = UserDeputyCommander
      when 'leader'
        role_id =UserCommander
      end
      role_id
    end
    
    def user_role(role_id)
      case role_id.to_i
      when UserRecruit
        role = 'Recruit'
      when UserSoldier
        role = 'Soldier'
      when UserTreasurer
        role = 'Treasurer'
      when UserRecruiter
        role = 'Recruiter'
      when UserDiplomat
        role = 'Diplomat'
      when UserCompanyCommander
        role = 'Company Commander'
      when UserDeputyCommander
        role = 'Deputy Commander'
      when UserCommander
        role = 'Commander'
      else
        role = 'Recruit'
      end      
      role
    end
  
    def clean_response(response)
        if response.parsed_response.class == Hash
          json_response = response.parsed_response
        else
          json_response = JSON.parse response.parsed_response  
        end                              
    end
  
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
        
    def request_wot_id
      url = "https://api.worldoftanks.com/wot/account/list/?application_id=#{ENV['WOT_API_KEY']}&search=#{CGI.escape self.name}&limit=1"
      response = self.class.get url     
      if response["status"] == 'ok'
        data = response["data"]            
        if data && data.count > 0 && !data[0].empty?
          self.update_attribute(:wot_id, data[0]["account_id"])
        else 
          Rails.logger.info "\n---> #{self.name}(#{self.id}) :> Unable to lookup WOT ID\n"
        end
      end
    end    
        
    def lookup_wot_id
      if Rails.env.test?
        if self.name == 'valid'
          self.update_attribute(:wot_id, '1001261893')
        end
      else
        Thread.new do
          request_wot_id
          ActiveRecord::Base.connection.close
        end
      end
    end
end
