json.array!(@sub_categories) do |sub_category|
  json.extract! sub_category, :id, :name
end