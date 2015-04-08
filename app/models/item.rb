class Item < ActiveRecord::Base
  belongs_to :category
  belongs_to :sub_category
  validates :name, presence: true
end
