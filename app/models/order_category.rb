class OrderCategory < ActiveRecord::Base
  has_many :service_order_category_links, dependent: :destroy
  has_many :services, through: :service_order_category_links
  has_many :orders, dependent: :nullify
end
