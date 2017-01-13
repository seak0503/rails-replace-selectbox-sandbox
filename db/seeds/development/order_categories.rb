categories = %w(
  ORDER:受注
  CANCELLATION:解約
  NEW_CUSTOMER_ORDER:新規顧客受注
  EXISTING_CUSTOMER_ORDER:既存顧客受注
  REMOTE_HAND:リモートハンド
  FIXED_TERM_WORK:定期作業
)

# カテゴリ作成
categories.each do |category|
  c = category.split(':')
  OrderCategory.create!(
    order_category_key: c[0],
    name: c[1]
  )
end

# c9FlexとDCサービス以外との関連づけ
services = Service.where.not(
  "services.service_key = ? OR services.service_key = ?",
  "CLOUD", "DC")
categories = OrderCategory.where(
  "order_categories.order_category_key = ? OR order_categories.order_category_key = ?",
  "ORDER", "CANCELLATION")
services.each do |service|
  categories.each_with_index do |category, index|
    ServiceOrderCategoryLink.create!(
      service_id: service.id,
      order_category_id: category.id,
      display_order: index
    )
  end
end

# c9Flexサービスのみとの関連付け
service = Service.find_by(service_key: "CLOUD")
categories = OrderCategory.where(
  "order_categories.order_category_key = ? OR order_categories.order_category_key = ? OR order_categories.order_category_key = ?",
  "NEW_CUSTOMER_ORDER", "EXISTING_CUSTOMER_ORDER", "CANCELLATION")
categories.each_with_index do |category, index|
  ServiceOrderCategoryLink.create!(
    service_id: service.id,
    order_category_id: category.id,
    display_order: index
  )
end

# DCサービスのみとの関連付け
service = Service.find_by(service_key: "DC")
categories = OrderCategory.where(
  "order_categories.order_category_key = ? OR order_categories.order_category_key = ? OR order_categories.order_category_key = ? OR order_categories.order_category_key = ?",
  "ORDER", "CANCELLATION", "REMOTE_HAND", "FIXED_TERM_WORK")
categories.each_with_index do |category, index|
  ServiceOrderCategoryLink.create!(
    service_id: service.id,
    order_category_id: category.id,
    display_order: index
  )
end
