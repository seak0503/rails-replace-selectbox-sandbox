Item.destroy_all
SubCategory.destroy_all
Category.destroy_all

{'本' => %w(和書 洋書 コミック 雑誌), '家電・カメラ・AV機器' => %w(家電 カメラ オーディオ), 'ホーム・キッチン' => %w(キッチン用品 雑貨 カーテン)}.each do |category_name, sub_category_names|
  category = Category.create(name: category_name)
  sub_category_names.each do |sub_category_name|
    category.sub_categories.create(name: sub_category_name)
  end
end

[%w(Rails入門 和書), %w(コンパクトスピーカー オーディオ), %w(鉄鍋 キッチン用品)].each do |item_name, sub_category_name|
  sub_category = SubCategory.find_by_name sub_category_name
  Item.create(name: item_name, category: sub_category.category, sub_category: sub_category)
end

table_names = %w(services order_categories destgroups orders)
table_names.each do |table_name|
  path = Rails.root.join('db', 'seeds', "development", "#{table_name}.rb")
  #path = Rails.root.join('db', 'seeds', "production", "#{table_name}.rb")
  if File.exist?(path)
    puts "Creating #{table_name}...."
    require(path)
  end
end
