class Item < ActiveRecord::Base
  belongs_to :category
  belongs_to :sub_category
  validates :name, presence: true
  validates :category, :category_id, presence: true
  validates :sub_category, :sub_category_id, presence: true
end
