class Video < ActiveRecord::Base  
  require 'json'
  
  # Associations
  belongs_to :clan
  belongs_to :access_type
  
  # Validation Classes
  class ContentValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      if record.youtube_channel.blank? && record.video_list.blank?
        record.errors.add(attribute, "Must have a YouTube Channel or a Video List")    
      end
    end
  end  
  
  class JsonValidator < ActiveModel::EachValidator    
    def validate_each(record, attribute, value)
      if value.blank?
        return true
      end
      if not value.is_a?(String)
        record.errors.add(attribute, "Invalid Json")
      else
        begin
          !!JSON.parse(value)
        rescue
          record.errors.add(attribute, "Invalid Json")
        end  
      end 
    end              
  end  
  
  # Validations
  validates :title, presence: true, length: { maximum: 50 }
  validates :disqus, presence: true, length: { maximum: 30 }
  validates :header, presence: true, length: { maximum: 256 }
  validates :youtube_channel, content: true, length: { maximum: 56 }
  validates :video_list, content: true, json: true
  validates :filters, json: true
  validates :clan_id, presence: true
  validates :access_type_id, presence:true
  
  # Friendly ID
  extend FriendlyId
  friendly_id :slug_canditates, use: :slugged 
  
  def slug_canditates
    if self.clan
      [
        [self.clan.clan_short_name, :title]
      ]
    else
      [
        [:title]
      ]
    end
  end 
end
