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
    # 新規作成画面を開く
    visit root_path
    click_on 'New Item'

    # セレクトボックスのデフォルト値を検証する
    expect(page).to have_select 'Category', options: ['', '本', '家電・カメラ・AV機器']
    expect(page).to have_select 'Sub category', options: ['']

    # カテゴリを変更するとサブカテゴリの項目が変わることを検証する
    select '本', from: 'Category'
    expect(page).to have_select 'Sub category', options: ['', '和書', '洋書']
    select '家電・カメラ・AV機器', from: 'Category'
    expect(page).to have_select 'Sub category', options: ['', '家電', 'カメラ']

    # バリデーションエラーが発生してもセレクトボックスの内容が保持されることを検証する
    select '家電', from: 'Sub category'
    click_on 'Save'
    expect(page).to have_content "can't be blank"
    expect(page).to have_select 'Category', selected: '家電・カメラ・AV機器', options: ['', '本', '家電・カメラ・AV機器']
    expect(page).to have_select 'Sub category', selected: '家電', options: ['', '家電', 'カメラ']

    # 入力値が正しく保存されることを検証する
    fill_in 'Name', with: '全自動洗濯機'
    click_on 'Save'
    expect(page).to have_content 'Item was successfully created.'
    expect(page).to have_content '全自動洗濯機'
    expect(page).to have_content '家電・カメラ・AV機器'
    expect(page).to have_content '家電'

    # 編集画面を開いてもセレクトボックスの内容が保持されることを検証する
    click_on 'Edit'
    expect(page).to have_field 'Name', with: '全自動洗濯機'
    expect(page).to have_select 'Category', selected: '家電・カメラ・AV機器', options: ['', '本', '家電・カメラ・AV機器']
    expect(page).to have_select 'Sub category', selected: '家電', options: ['', '家電', 'カメラ']

    # データが正しく更新されることを検証する
    fill_in 'Name', with: 'Everyday Rails Testing with RSpec'
    select '本', from: 'Category'
    select '洋書', from: 'Sub category'
    click_on 'Save'
    expect(page).to have_content 'Item was successfully updated.'
    expect(page).to have_content 'Everyday Rails Testing with RSpec'
    expect(page).to have_content '本'
    expect(page).to have_content '洋書'

    # 一覧画面での表示内容を検証する
    click_on 'Back'
    expect(page).to have_content 'Listing items'
    expect(page).to have_content 'Everyday Rails Testing with RSpec'
    expect(page).to have_content '本'
    expect(page).to have_content '洋書'

    # データの削除が行えることを検証する
    click_on 'Destroy'
    expect(page).to have_content 'Item was successfully destroyed.'
    expect(page).to_not have_content 'Everyday Rails Testing with RSpec'
  end
end