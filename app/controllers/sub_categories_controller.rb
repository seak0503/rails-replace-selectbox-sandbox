class SubCategoriesController < ApplicationController
  def index
    category = Category.find(params[:category_id])
    render json: category.sub_categories.select(:id, :name)
  end
end