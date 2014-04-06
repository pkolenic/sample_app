class RuneGlyph < ActiveRecord::Base
  # Associations
  belongs_to :item_type
  belongs_to :essence_rune
  belongs_to :aspect_rune
  belongs_to :potency_rune
  
  # Validation Classes
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
  validates :name, presence: true, length: { maximum: 64 }
  validates :description, presence: true, length: { maximum: 128 }
  validates :x_value, optional_value: true
  validates :y_value, optional_value: true       
  validates :item_type_id, presence: true, numericality: { greater_than: 0 }
  validates :essence_rune_id, presence: true, numericality: { greater_than: 0 }
  validates :aspect_rune_id, presence: true, numericality: { greater_than: 0 }
  validates :potency_rune_id, presence: true, numericality: { greater_than: 0 }      
end
