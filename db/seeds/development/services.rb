parent_services = %w(
  NETWORK:ネットワーク
  DC:DCサービス
  MSP:MSP
  CLOUD:c9Flex
  SAAS:SaaS
  JPIX:JPIX
)

child_services = %w(
  CLOUD_1:GrowServer:CLOUD
  SAAS_1:BBTower\ WAF:SaaS
)

# 親サービスの作成
parent_services.each do |service|
  s = service.split(':')
  Service.create!(
    service_key: s[0],
    name: s[1]
  )
end

# 子サービスの作成
child_services.each do |service|
  s = service.split(':')
  parent_service = Service.find_by(service_key: s[2])
  Service.create!(
    parent_service_id: parent_service.id,
    service_key: s[0],
    name: s[1]
  )
end
