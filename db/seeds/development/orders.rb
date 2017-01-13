destg = [Destgroup.find(1)]

contract_number = "201504000"
category_keys = %w(
  ORDER
  CANCELLATION
  NEW_CUSTOMER_ORDER
  EXISTING_CUSTOMER_ORDER
  REMOTE_HAND
  FIXED_TERM_WORK
)

# 種別があるオーダのデータ追加
category_keys.each_with_index do |category_key, i|
  category = OrderCategory.find_by(order_category_key: category_key)
  i = (i + 1).to_s
  order = Order.create!(
    contract_number: contract_number + i,
    destgroups: destg,
    order_category_id: category.id
  )
end
