class Tournament < ActiveRecord::Base
  before_create :add_owner_to_team
  before_save :fix_urls
  
  # Validation Classes
  class EndDateValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      if (!value.nil?)
        if !record.end_date.nil? && !record.start_date.nil?
          record.errors[attribute] << 'model.errors.custom.end_date' if record.start_date > record.end_date
        end
      end
    end
  end

  class StartDateValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      if (!value.nil?)
        if !record.start_date.nil?
          record.errors[attribute] << I18n.t('model.errors.custom.start_date') if DateTime.now > record.start_date
        end
      end
    end
  end
  
  class MaximumTeamValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      if (!value.nil?)
        if !record.maximum_team_size? && !record.minimum_team_size?
           record.errors[attribute] << I18n.t('model.errors.custom.maximum_team_size') if record.maximum_team_size < record.minimum_team_size
        end
      end
    end
  end
  
  class TeamTierValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      if (!value.nil?)
        if !record.team_maximum_tier_points? && !record.minimum_team_size?
           record.errors[attribute] << I18n.t('model.errors.custom.team_maximum_tier_points') if record.team_maximum_tier_points < record.minimum_team_size
        end
        if record.minimum_team_size?
          record.errors[attribute] << I18n.t('model.errors.custom.team_maximum_tier_points') if record.team_maximum_tier_points < record.minimum_team_size
        end
      end
    end
  end
  
  # Association
  belongs_to :user

  # Scope
  default_scope -> { order('start_date ASC') }

  # Validations
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 60 }
  validates :team_name, presence: true, length: { maximum: 45 }
  validates :password, length: { maximum: 30 }
  validates :minimum_team_size, presence: true, numericality: { greater_than: 1 }
  validates :maximum_team_size, presence: true, maximum_team: true
  validates :heavy_tier_limit, presence: true, numericality: { greater_than: 0 }
  validates :medium_tier_limit, presence: true, numericality: { greater_than: 0 }
  validates :td_tier_limit, presence: true, numericality: { greater_than: 0 }
  validates :light_tier_limit, presence: true, numericality: { greater_than: 0 }
  validates :spg_tier_limit, presence: true, numericality: { greater_than: 0 }
  validates :team_maximum_tier_points, presence: true, team_tier: true
  validates :start_date, presence: true, start_date: true
  validates :end_date, presence: true, end_date: true

  validate  :ensure_team_less_or_equal_to_max_team_size

  def ensure_team_less_or_equal_to_max_team_size
    members = self.team.split(',').length
    if members > self.maximum_team_size.to_i
      errors.add(:team, 'team is too large')
    end
  end
  
  private
    def fix_urls
      if !%w( http https ).include?(self.wot_tournament_link)
        self.wot_tournament_link = "http://#{self.wot_tournament_link}"
      end
      if !%w( http https ).include?(self.wot_team_link)
        self.wot_team_link = "http://#{self.wot_team_link}"
      end
    end
    
    def add_owner_to_team
      self.team = "#{self.user_id}"
    end
end
