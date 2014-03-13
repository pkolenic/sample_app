class Event < ActiveRecord::Base
  belongs_to :user
  
  default_scope -> { order('start_time DESC') }
  
    # Validation Classes
  class EndTimeValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      if (!value.nil?)
        if !record.end_time.nil? && !record.start_time.nil?
          record.errors[attribute] << 'can not be before the Start Time' if record.start_time > record.end_time
        end
      end
    end
  end
  
  # Validations
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 72 }
  validates :deck, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true, end_time: true
end
