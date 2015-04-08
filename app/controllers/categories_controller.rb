class CategoriesController < ApplicationController
  def sub_categories
    category = Category.find(params[:category_id])
    @sub_categories = category.sub_categories
    respond_to do |format|
      format.json
    end
  end
end