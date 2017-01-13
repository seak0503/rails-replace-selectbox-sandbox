class OrderCategoriesController < ApplicationController
  def index
    destgroup = Destgroup.find(params[:order_id])
    render json: destgroup.services.joins('INNER JOIN service_order_category_links ON services.id = service_order_category_links.service_id').joins('INNER JOIN order_categories ON service_order_category_links.order_category_id = order_categories.id').select('order_categories.id, order_categories.name')
  end
end
