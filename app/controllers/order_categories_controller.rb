class OrderCategoriesController < ApplicationController
  def destgroups_order_categories
    p params[:id]
    destgroups = Destgroup.where(id: params[:id])
    render json: destgroups.joins(:services).joins('INNER JOIN service_order_category_links ON services.id = service_order_category_links.service_id').joins('INNER JOIN order_categories ON service_order_category_links.order_category_id = order_categories.id').select('order_categories.id, order_categories.name').distinct
  end
end
