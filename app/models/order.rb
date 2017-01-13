class Order < ActiveRecord::Base
  has_and_belongs_to_many :destgroups
  belongs_to :order_category
end
