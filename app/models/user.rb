class User < ActiveRecord::Base
  include HTTParty
  
  has_secure_password
  before_save { email.downcase! }
  before_create :create_remember_token
  after_create :lookup_wot_id

  # Associations
  has_many :tournaments, dependent: :destroy

  # Validation Classes
  class WotNameValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      if (!value.nil?)
        if record.id.nil?
          existing_user = User.find_by(wot_name: record.wot_name)
          record.errors['World'] << 'of Tanks Name already in use' if existing_user && existing_user.active?
        end
      end
    end
  end

  # Validations
  validates :name, presence: true, length: { maximum: 50 }
  validates :wot_name, presence: true, length: { maximum: 50 }, wot_name: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :password, length: { minimum: 6 }
  
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
    if self.role >= UserDeputyCommander
      if user.role >= UserSoldier
        true
      else 
        false
      end
      else
        false
    end
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

 def update_stats
    if self.wot_id
      if Rails.env.test?
        total =  { 
                    "achievements" => {}, 
                    "ratings" => {}, 
                    "name" => 'articblast', 
                    "vehicles" => {}, 
                    "battles" => {
                      "spotted" => 1000,
                      "frags" => 1500,
                      "damage_dealt" => 1000000,
                      "hits_percents" => 55,
                      "capture_points" => 5000,
                      "dropped_capture_points" => 6000
                    }, 
                    "summary" => {
                      "battles_count" => 3000,
                      "wins" => 1500,
                      "losses" => 1000,
                      "survived_battles" => 450
                    }, 
                    "experience" => {
                      "xp" => 1500000,
                      "max_xp" => 1000
                    }, 
                    "clan" => {
                      "member" => { "role" => "recruiter"}, 
                      "clan" => {
                        "id" => "1000007730", 
                        "name" => self.clan_name, 
                        "abbreviation" => "FTF",
                        "emblems_urls" => { "large" => "http://cw.worldoftanks.com/media/clans/emblems/clans_1/1000007730/emblem_64x64.png" }}}}
        json_response = { "status" => 'ok', "data" => total }
      else 
        url = "http://api.worldoftanks.com/2.0/account/info/?application_id=16924c431c705523aae25b6f638c54dd&account_id=#{self.wot_id}"
        response = self.class.get url
        if response.parsed_response.class == Hash
          json_response = response.parsed_response
        else
          json_response = JSON.parse response.parsed_response  
        end
      end
 
      if json_response["status"] == 'ok'
        total = json_response["data"]["#{self.wot_id}"]
        if !total.blank? 
          # Clan Details
          if !total["clan"].blank?       
            clan_id = total["clan"]["clan_id"]                 
            self.clan_id = clan_id
            clan_url = "http://api.worldoftanks.com/2.0/clan/info/?application_id=16924c431c705523aae25b6f638c54dd&clan_id=#{clan_id}"
            clan_response = self.class.get clan_url
            if clan_response.parsed_response.class == Hash
              clan = clan_response.parsed_response
            else
              clan = JSON.parse response.parsed_response
            end
            
            if clan && clan['status'] == 'ok'
              clan = clan['data']["#{clan_id}"]
              
              self.clan_name = clan["name"]
              self.clan_abbr = clan["abbreviation"]
              self.clan_logo = clan["emblems"]["large"]                                    
            end

            if self.role > UserPending || !self.active?
              previous_role = self.role
              self.role = convert_role(total["clan"]["role"], clan_id)
              if previous_role != self.role 
                if self.role == UserAmbassador && self.active?
                  UserMailer.made_ambassador(self).deliver
                elsif self.role > previous_role && self.active?
                  UserMailer.promoted(self, user_role(self.role), '').deliver
                elsif self.active?
                  UserMailer.demoted(self, user_role(self.role), 'Auto Sent based on action taken on the Official World of Tank Clan page.').deliver
                end
              end
            end
          else
            self.clan_id = nil
            self.role = UserRecruit
          end
          
          # Total Stats
          if total["statistics"]
            self.battles_count = total["statistics"]["all"]["battles"]
            self.wins = total["statistics"]["all"]["wins"]
            self.losses = total["statistics"]["all"]["losses"] 
            self.survived = total["statistics"]["all"]["survived_battles"]
            self.experiance = total["statistics"]["all"]["xp"]
            self.max_experiance = total["statistics"]["max_xp"]
            self.spotted = total["statistics"]["all"]["spotted"]
            self.frags = total["statistics"]["all"]["frags"]
            self.damage_dealt = total["statistics"]["all"]["damage_dealt"]
            self.hit_percentage = total["statistics"]["all"]["hits_percents"]
            self.capture_points = total["statistics"]["all"]["capture_points"]
            self.defense_points = total["statistics"]["all"]["dropped_capture_points"]
            # self.avg_tier = calculate_avg_tier(total["vehicles"])
          end
                      
          self.save validate: false
          self.touch
        end
      end
    end
  end

  private
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
  
    def convert_role(role, clan_id)      
      if clan_id == 1000007730
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
      else
        role_id = UserAmbassador
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
  
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
        
    def lookup_wot_id
      if Rails.env.test?
        if self.wot_name == 'valid'
          self.update_attribute(:wot_id, '1001261893')
        end
      else
        Thread.new do
          response = self.class.get "http://api.worldoftanks.com/2.0/account/list/?application_id=16924c431c705523aae25b6f638c54dd&search=#{self.wot_name}&limit=1"
          if response["status"] == 'ok'
            data = response["data"]
            if data.count && !data[0].empty?
              self.update_attribute(:wot_id, data[0]["id"])
            end
          end
          ActiveRecord::Base.connection.close
        end
      end
    end
end
