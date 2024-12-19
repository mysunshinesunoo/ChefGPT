class Recipe < ApplicationRecord
  validates :name, presence: true
  validates :recipe_type, presence: true
  validates :description, presence: true
  validates :steps, presence: true
  validates :nutrition_rating, presence: true, 
            numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :prep_time, presence: true

  # If steps is stored as a string, serialize it as an array
  serialize :steps, Array
end
