class User < ActiveRecord::Base
  include HTTParty
  
  has_secure_password
  before_save { email.downcase! }
  before_create :create_remember_token
  before_create :set_pending_status
  after_create :lookup_wot_id

  # Validations
  validates :name, presence: true, length: { maximum: 50 }
  validates :wot_name, presence: true, length: { maximum: 50 }

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
        stats = []
        total = { "stats" => 
                  { 
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
                        "emblems_urls" => { "large" => "http://cw.worldoftanks.com/media/clans/emblems/clans_1/1000007730/emblem_64x64.png" }}}}}
        stats[0] = total
        json_response = { "status" => 'ok', "stats" => stats }
      else 
        url = "http://dvstats.wargaming.net/userstats/2/stats/slice/?platform=android&server=us&account_id=#{self.wot_id}&hours_ago=0&hours_ago=24&hours_ago=168&hours_ago=720&hours_ago=1440"
        response = self.class.get url
        if response.parsed_response.class == Hash
          json_response = response.parsed_response
        else
          json_response = JSON.parse response.parsed_response  
        end
      end
 
      if json_response["status"] == 'ok'
        data = json_response["stats"]
         if !data.empty? 
          total = data[0]["stats"]
          
          # Clan Details
          self.clan_id = total["clan"]["clan"]["id"]
          self.clan_name = total["clan"]["clan"]["name"]
          self.clan_abbr = total["clan"]["clan"]["abbreviation"]
          self.clan_logo = total["clan"]["clan"]["emblems_urls"]["large"]
          
          if self.role > UserPending
            previous_role = self.role
            self.role = convert_role(total["clan"]["member"]["role"], total["clan"]["clan"]["name"])
            if previous_role != self.role 
              if self.role == UserAmbassador
                UserMailer.made_ambassador(self).deliver
              elsif self.role > previous_role
                UserMailer.promoted(self, user_role(self.role), '').deliver
              else 
                UserMailer.demoted(self, user_role(self.role), 'Auto Sent based on action taken on the Official World of Tank Clan page.').deliver
              end
            end
          end
          
          # Total Stats
          self.battles_count = total["summary"]["battles_count"]
          self.wins = total["summary"]["wins"]
          self.losses = total["summary"]["losses"] 
          self.survived = total["summary"]["survived_battles"]
          self.experiance = total["experience"]["xp"]
          self.max_experiance = total["experience"]["max_xp"]
          self.spotted = total["battles"]["spotted"]
          self.frags = total["battles"]["frags"]
          self.damage_dealt = total["battles"]["damage_dealt"]
          self.hit_percentage = total["battles"]["hits_percents"]
          self.capture_points = total["battles"]["capture_points"]
          self.defense_points = total["battles"]["dropped_capture_points"]
          self.avg_tier = calculate_avg_tier(total["vehicles"])
          
          if !Rails.env.test?
            # 24 hrs
            stats = data[1]["stats"]
            self.battles_count_24hr = self.battles_count - stats["summary"]["battles_count"]
            self.wins_24hr = self.wins - stats["summary"]["wins"]
            self.losses_24hr = self.losses - stats["summary"]["losses"] 
            self.survived_24hr = self.survived - stats["summary"]["survived_battles"]
            self.experiance_24hr = self.experiance - stats["experience"]["xp"]
            self.spotted_24hr = self.spotted - stats["battles"]["spotted"]
            self.frags_24hr = self.frags - stats["battles"]["frags"]
            self.damage_dealt_24hr = self.damage_dealt - stats["battles"]["damage_dealt"]
            self.hit_percentage_24hr = self.hit_percentage - stats["battles"]["hits_percents"]
            self.capture_points_24hr = self.capture_points - stats["battles"]["capture_points"]
            self.defense_points_24hr = self.defense_points - stats["battles"]["dropped_capture_points"]
            self.avg_tier_24hr = calculate_avg_tier(stats["vehicles"])
            
            # 7 days
            stats = data[2]["stats"]
            self.battles_count_7day = self.battles_count - stats["summary"]["battles_count"]
            self.wins_7day = self.wins - stats["summary"]["wins"]
            self.losses_7day = self.losses - stats["summary"]["losses"] 
            self.survived_7day = self.survived - stats["summary"]["survived_battles"]
            self.experiance_7day = self.experiance - stats["experience"]["xp"]
            self.spotted_7day = self.spotted - stats["battles"]["spotted"]
            self.frags_7day = self.frags - stats["battles"]["frags"]
            self.damage_dealt_7day = self.damage_dealt - stats["battles"]["damage_dealt"]
            self.hit_percentage_7day = self.hit_percentage - stats["battles"]["hits_percents"]
            self.capture_points_7day = self.capture_points - stats["battles"]["capture_points"]
            self.defense_points_7day = self.defense_points - stats["battles"]["dropped_capture_points"]
            self.avg_tier_7day = calculate_avg_tier(stats["vehicles"])
            
            # 30 days
            stats = data[3]["stats"]
            self.battles_count_30day = self.battles_count - stats["summary"]["battles_count"]
            self.wins_30day = self.wins - stats["summary"]["wins"]
            self.losses_30day = self.losses - stats["summary"]["losses"] 
            self.survived_30day = self.survived - stats["summary"]["survived_battles"]
            self.experiance_30day = self.experiance - stats["experience"]["xp"]
            self.spotted_30day = self.spotted - stats["battles"]["spotted"]
            self.frags_30day = self.frags - stats["battles"]["frags"]
            self.damage_dealt_30day = self.damage_dealt - stats["battles"]["damage_dealt"]
            self.hit_percentage_30day = self.hit_percentage - stats["battles"]["hits_percents"]
            self.capture_points_30day = self.capture_points - stats["battles"]["capture_points"]
            self.defense_points_30day = self.defense_points - stats["battles"]["dropped_capture_points"]
            self.avg_tier_30day = calculate_avg_tier(stats["vehicles"])
            
            # 60 days
            stats = data[4]["stats"]
            self.battles_count_60day = self.battles_count - stats["summary"]["battles_count"]
            self.wins_60day = self.wins - stats["summary"]["wins"]
            self.losses_60day = self.losses - stats["summary"]["losses"] 
            self.survived_60day = self.survived - stats["summary"]["survived_battles"]
            self.experiance_60day = self.experiance - stats["experience"]["xp"]
            self.spotted_60day = self.spotted - stats["battles"]["spotted"]
            self.frags_60day = self.frags - stats["battles"]["frags"]
            self.damage_dealt_60day = self.damage_dealt - stats["battles"]["damage_dealt"]
            self.hit_percentage_60day = self.hit_percentage - stats["battles"]["hits_percents"]
            self.capture_points_60day = self.capture_points - stats["battles"]["capture_points"]
            self.defense_points_60day = self.defense_points - stats["battles"]["dropped_capture_points"]
            self.avg_tier_60day = calculate_avg_tier(stats["vehicles"])
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
  
    def convert_role(role, clan)
      if clan == 'Fear the Fallen'
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
    
    def set_pending_status
      self.role = UserPending
    end
    
    def lookup_wot_id
      if Rails.env.test?
        if self.wot_name == 'valid'
          self.update_attribute(:wot_id, '1001261893')
        end
      else
        Thread.new do
          response = self.class.get "http://api.worldoftanks.com/uc/accounts/api/1.1/?source_token=WG-WoT_Assistant-1.3.2&search=#{self.wot_name}&offset=0&limit=1"
          json_response = JSON.parse response.parsed_response      
          if json_response["status"] == 'ok'
            data = json_response["data"]
            if !data["items"].empty?
              self.update_attribute(:wot_id, data["items"][0]["id"])
            end
          end
          ActiveRecord::Base.connection.close
        end
      end
    end
end
