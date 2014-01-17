class Tournament < ActiveRecord::Base
  before_validation :add_owner_to_team
  before_save :fix_urls
  # Validation Classes
  class EndDateValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      if (!value.nil?)
        if !record.end_date.nil? && !record.start_date.nil?
          record.errors[attribute] << 'can not be before the Start Date' if record.start_date > record.end_date
        end
      end
    end
  end

  class MaximumTeamValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      if (!value.nil?)
        if !record.maximum_team_size? && !record.minimum_team_size?
          record.errors[attribute] << 'model.errors.custom.maximum_team_size' if record.maximum_team_size < record.minimum_team_size
        end
        if record.maximum_team_size? && record.minimum_team_size?
          record.errors[attribute] << 'can not be less than Minimum Team Size' if record.maximum_team_size < record.minimum_team_size
        end
      end
    end
  end

  class TeamTierValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      if (!value.nil?)
        if !record.team_maximum_tier_points? && !record.minimum_team_size?
          record.errors[attribute] << 'can not be blank' if record.team_maximum_tier_points < record.minimum_team_size
        end
        if record.minimum_team_size?
          record.errors[attribute] << 'can not be less than the Minimum Team Size' if record.team_maximum_tier_points < record.minimum_team_size
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
  validates :heavy_tier_limit, presence: true, numericality: { less_than: 11 }
  validates :medium_tier_limit, presence: true, numericality: { less_than: 11 }
  validates :td_tier_limit, presence: true, numericality: { less_than: 11 }
  validates :light_tier_limit, presence: true, numericality: { less_than: 11 }
  validates :spg_tier_limit, presence: true, numericality: { less_than: 11 }
  validates :team_maximum_tier_points, presence: true, team_tier: true
  validates :start_date, presence: true
  validates :end_date, presence: true, end_date: true
  validates :wot_tournament_link, presence: true
  validates :wot_team_link, presence: true

  validate  :ensure_team_less_or_equal_to_max_team_size

  def ensure_team_less_or_equal_to_max_team_size
    members = self.team.split(',').length
    if members > self.maximum_team_size.to_i
      errors.add(:team, 'is too large')
    end
  end

  private

  def uri?(string)
    uri = URI.parse(string)
    %w( http https ).include?(uri.scheme)
    rescue URI::BadURIError
      false
    rescue URI::InvalidURIError
      false
  end

  def fix_urls
    if !self.wot_tournament_link.blank? && !uri?(self.wot_tournament_link)
      self.wot_tournament_link = "http://#{self.wot_tournament_link}"
    end
    if !self.wot_team_link.blank? && !uri?(self.wot_team_link)
      self.wot_team_link = "http://#{self.wot_team_link}"
    end
  end

  def add_owner_to_team
    if self.team.blank?
      self.team = "#{self.user_id}"
    end
  end
end
