dest_group_names = %w(
  Network(L):NETWORK
  DCサービス:DC
  GrowServer:SAAS_1
  c9Flex:SAAS
  MSP:MSP
  BBTower\ WAF:SAAS_1
  SI/NI(JPIX):JPIX
  SaaS:SAAS
)

dest_group_names.each do |group|
  g = group.split(':')
  services = Service.where(service_key: g[1])
  Destgroup.create!(
    name: g[0],
    services: services
  )
end

