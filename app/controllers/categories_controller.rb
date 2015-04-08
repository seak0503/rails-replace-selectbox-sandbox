class CategoriesController < ApplicationController
  def sub_categories
    category = Category.find(params[:category_id])
    render json: category.sub_categories
  end
end