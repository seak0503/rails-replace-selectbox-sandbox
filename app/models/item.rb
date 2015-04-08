class Item < ActiveRecord::Base
  belongs_to :category
  belongs_to :sub_category
  validates :name, presence: true
  validates :category, presence: true
  validates :sub_category, presence: true
end
