class ServiceOrderCategoryLink < ActiveRecord::Base
  belongs_to :service
  belongs_to :order_category
end
