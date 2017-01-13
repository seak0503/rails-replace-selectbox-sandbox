class Service < ActiveRecord::Base
  belongs_to :parent_service, class_name: 'Service'
  has_many :child_services, class_name: 'Service', foreign_key: 'parent_service_id', dependent: :nullify
  has_many :service_order_category_links, dependent: :destroy
  has_many :order_categories, through: :service_order_category_links
  has_and_belongs_to_many :destgroups
end
