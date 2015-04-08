json.array!(@sub_categories) do |sub_category|
  # セキュリティ面に考慮して不要な項目を返却しないようにする
  json.extract! sub_category, :id, :name
end