json.array!(@orders) do |order|
  json.extract! order, :id, :contract_number, :customer_number, :delivery_date, :status, :web_url, :order_comment
  json.url order_url(order, format: :json)
end
