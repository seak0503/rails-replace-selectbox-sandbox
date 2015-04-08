require 'rails_helper'

feature 'Items' do
  background do
    {'本' => %w(和書 洋書), '家電・カメラ・AV機器' => %w(家電 カメラ)}.each do |category_name, sub_category_names|
      category = Category.create(name: category_name)
      sub_category_names.each do |sub_category_name|
        category.sub_categories.create(name: sub_category_name)
      end
    end
  end
  scenario 'Manage items', js: true do
    visit root_path
    click_on 'New Item'

    fill_in 'Name', with: 'Rails入門'
    expect(page).to have_select('Category', options: ['', '本', '家電・カメラ・AV機器'])
    expect(page).to have_select('Sub category', options: [''])
    select '本', from: 'Category'
    expect(page).to have_select('Sub category', options: ['', '和書', '洋書'])
    select '和書', from: 'Sub category'
  end
end