class Category < ActiveRecord::Base
  has_many :sub_categories, ->{ order(:id) }
end
