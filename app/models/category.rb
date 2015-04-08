class Category < ActiveRecord::Base
  has_many :sub_categories, ->{ order(:id) }
  validates :name, presence: true
end
