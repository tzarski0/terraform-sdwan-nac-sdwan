resource "sdwan_cli_config_profile_parcel" "cli_config_profile_parcel" {
  for_each = {
    for cli in try(local.feature_profiles.cli_profiles, {}) :
    "${cli.name}-config" => cli
    if try(cli.config, null) != null
  }
  name               = try(each.value.config.name, "${each.value.name}-config")
  description        = try(each.value.config.description, "")
  feature_profile_id = sdwan_cli_feature_profile.cli_feature_profile[each.value.name].id
  cli_configuration  = each.value.config.cli_configuration
}

resource "sdwan_system_aaa_profile_parcel" "system_aaa_profile_parcel" {
  for_each = {
    for sys in try(local.feature_profiles.system_profiles, {}) :
    "${sys.name}-aaa" => sys
    if try(sys.aaa, null) != null
  }
  name                      = try(each.value.aaa.name, "${each.value.name}-aaa")
  description               = try(each.value.aaa.description, null)
  feature_profile_id        = sdwan_system_feature_profile.system_feature_profile[each.value.name].id
  accounting_group          = try(each.value.aaa.dot1x_accounting, null)
  accounting_group_variable = try("{{${each.value.aaa.dot1x_accounting_variable}}}", null)
  accounting_rules = try(length(each.value.aaa.accounting_rules) == 0, true) ? null : [for rule in each.value.aaa.accounting_rules : {
    group               = rule.groups
    level               = try(rule.level, null)
    method              = rule.method
    rule_id             = rule.id
    start_stop          = try(rule.start_stop, null)
    start_stop_variable = try(rule.start_stop_variable, null)
  }]
  authentication_group                   = try(each.value.aaa.dot1x_authentication, null)
  authentication_group_variable          = try("{{${each.value.aaa.dot1x_authentication_variable}}}", null)
  authorization_config_commands          = try(each.value.aaa.authorization_config_commands, null)
  authorization_config_commands_variable = try("{{${each.value.aaa.authorization_config_commands_variable}}}", null)
  authorization_console                  = try(each.value.aaa.authorization_console, null)
  authorization_console_variable         = try("{{${each.value.aaa.authorization_console_variable}}}", null)
  authorization_rules = try(length(each.value.aaa.authorization_rules) == 0, true) ? null : [for rule in each.value.aaa.authorization_rules : {
    group            = rule.groups
    if_authenticated = try(rule.authenticated, null)
    level            = try(rule.level, null)
    method           = rule.method
    rule_id          = rule.id
  }]
  radius_groups = try(length(each.value.aaa.radius_groups) == 0, true) ? null : [for group in each.value.aaa.radius_groups : {
    group_name = try("radius-${group.vpn}", "radius-0-0")
    servers = !can(group.servers) ? null : [for server in group.servers : {
      acct_port           = try(server.accounting_port, null)
      acct_port_variable  = try("{{${server.accounting_port_variable}}}", null)
      address             = server.address
      auth_port           = try(server.authentication_port, null)
      auth_port_variable  = try("{{${server.authentication_port_variable}}}", null)
      key                 = server.key
      key_type            = try(server.key_type, null)
      key_type_variable   = try("{{${server.key_type_variable}}}", null)
      retransmit          = try(server.retransmit, null)
      retransmit_variable = try("{{${server.retransmit_variable}}}", null)
      secret_key          = try(server.secret_key, null)
      secret_key_variable = try("{{${server.secret_key_variable}}}", null)
      timeout             = try(server.timeout, null)
      timeout_variable    = try("{{${server.timeout_variable}}}", null)
    }]
    vpn                       = try(group.vpn, null)
    source_interface          = try(group.source_interface, null)
    source_interface_variable = try("{{${group.source_interface_variable}}}", null)
  }]
  server_auth_order = try(each.value.aaa.auth_order, local.defaults.sdwan.feature_profiles.system_profiles.aaa.auth_order)
  tacacs_groups = try(length(each.value.aaa.tacacs_groups) == 0, true) ? null : [for group in each.value.aaa.tacacs_groups : {
    group_name = try("tacacs-${group.vpn}", "tacacs-0-0")
    servers = !can(group.servers) ? null : [for server in group.servers : {
      address          = server.address
      key              = server.key
      port             = try(server.port, null)
      port_variable    = try("{{${server.port_variable}}}", null)
      secret_key       = server.secret_key
      timeout          = try(server.timeout, null)
      timeout_variable = try("{{${server.timeout_variable}}}", null)
    }]
    vpn                       = try(group.vpn, null)
    source_interface          = try(group.source_interface, null)
    source_interface_variable = try("{{${group.source_interface_variable}}}", null)
  }]
  users = try(length(each.value.aaa.users) == 0, true) ? null : [for user in each.value.aaa.users : {
    name               = try(user.name, null)
    name_variable      = try("{{${user.name_variable}}}", null)
    password           = try(user.password, null)
    password_variable  = try("{{${user.password_variable}}}", null)
    privilege          = try(user.privilege, null)
    privilege_variable = try("{{${user.privilege_variable}}}", null)
    public_keys = try(length(user.public_key_chains) == 0, true) ? null : [for public_key in user.public_key_chains : {
      key_type   = try(public_key.key_type, null)
      key_string = public_key.key_string
    }]
  }]
}

resource "sdwan_system_banner_profile_parcel" "system_banner_profile_parcel" {
  for_each = {
    for sys in try(local.feature_profiles.system_profiles, {}) :
    "${sys.name}-banner" => sys
    if try(sys.banner, null) != null
  }
  name               = try(each.value.banner.name, "${each.value.name}-banner")
  description        = try(each.value.banner.description, null)
  feature_profile_id = sdwan_system_feature_profile.system_feature_profile[each.value.name].id
  login              = try(each.value.banner.login, null)
  login_variable     = try("{{${each.value.banner.login_variable}}}", null)
  motd               = try(each.value.banner.motd, null)
  motd_variable      = try("{{${each.value.banner.motd_variable}}}", null)
}

resource "sdwan_system_bfd_profile_parcel" "system_bfd_profile_parcel" {
  for_each = {
    for sys in try(local.feature_profiles.system_profiles, {}) :
    "${sys.name}-bfd" => sys
    if try(sys.bfd, null) != null
  }
  name               = try(each.value.bfd.name, "${each.value.name}-bfd")
  description        = try(each.value.bfd.description, null)
  feature_profile_id = sdwan_system_feature_profile.system_feature_profile[each.value.name].id
  colors = try(length(each.value.bfd.colors) == 0, true) ? null : [for c in each.value.bfd.colors : {
    color                   = try(c.color, null)
    color_variable          = try("{{${c.color_variable}}}", null)
    dscp                    = try(c.default_dscp, null)
    dscp_variable           = try("{{${c.dscp_variable}}}", null)
    hello_interval          = try(c.hello_interval, null)
    hello_interval_variable = try("{{${c.hello_interval_variable}}}", null)
    multiplier              = try(c.multiplier, null)
    multiplier_variable     = try("{{${c.multiplier_variable}}}", null)
    pmtu_discovery          = try(c.pmtu_discovery, null)
    pmtu_discovery_variable = try("{{${c.pmtu_discovery_variable}}}", null)
  }]
  default_dscp           = try(each.value.bfd.default_dscp, null)
  default_dscp_variable  = try("{{${each.value.bfd.dscp_variable}}}", null)
  multiplier             = try(each.value.bfd.multiplier, null)
  multiplier_variable    = try("{{${each.value.bfd.multiplier_variable}}}", null)
  poll_interval          = try(each.value.bfd.poll_interval, null)
  poll_interval_variable = try("{{${each.value.bfd.poll_interval_variable}}}", null)
}

resource "sdwan_system_flexible_port_speed_profile_parcel" "system_flexible_port_speed_profile_parcel" {
  for_each = {
    for sys in try(local.feature_profiles.system_profiles, {}) :
    "${sys.name}-flexible_port_speed" => sys
    if try(sys.flexible_port_speed, null) != null
  }
  name               = try(each.value.flexible_port_speed.name, "${each.value.name}-flexible_port_speed")
  description        = try(each.value.flexible_port_speed.description, null)
  feature_profile_id = sdwan_system_feature_profile.system_feature_profile[each.value.name].id
  port_type          = try(each.value.flexible_port_speed.port_type, null)
  port_type_variable = try("{{${each.value.flexible_port_speed.port_type_variable}}}", null)
}

resource "sdwan_system_global_profile_parcel" "system_global_profile_parcel" {
  for_each = {
    for sys in try(local.feature_profiles.system_profiles, {}) :
    "${sys.name}-global" => sys
    if try(sys.global, null) != null
  }
  name                          = try(each.value.global.name, "${each.value.name}-global")
  description                   = try(each.value.global.description, null)
  feature_profile_id            = sdwan_system_feature_profile.system_feature_profile[each.value.name].id
  arp_proxy                     = try(each.value.global.arp_proxy, null)
  arp_proxy_variable            = try("{{${each.value.global.arp_proxy_variable}}}", null)
  cdp                           = try(each.value.global.cdp, null)
  cdp_variable                  = try("{{${each.value.global.cdp_variable}}}", null)
  console_logging               = try(each.value.global.console_logging, null)
  console_logging_variable      = try("{{${each.value.global.console_logging_variable}}}", null)
  domain_lookup                 = try(each.value.global.domain_lookup, null)
  domain_lookup_variable        = try("{{${each.value.global.domain_lookup_variable}}}", null)
  ftp_passive                   = try(each.value.global.ftp_passive, null)
  ftp_passive_variable          = try("{{${each.value.global.ftp_passive_variable}}}", null)
  http_authentication           = try(each.value.global.http_authentication, null)
  http_authentication_variable  = try("{{${each.value.global.http_authentication_variable}}}", null)
  http_server                   = try(each.value.global.http_server, null)
  http_server_variable          = try("{{${each.value.global.http_server_variable}}}", null)
  https_server                  = try(each.value.global.https_server, null)
  https_server_variable         = try("{{${each.value.global.https_server_variable}}}", null)
  ignore_bootp                  = try(each.value.global.ignore_bootp, null)
  ignore_bootp_variable         = try("{{${each.value.global.ignore_bootp_variable}}}", null)
  ip_source_routing             = try(each.value.global.ip_source_routing, null)
  ip_source_routing_variable    = try("{{${each.value.global.ip_source_routing_variable}}}", null)
  line_vty                      = try(each.value.global.telnet_outbound, null)
  line_vty_variable             = try("{{${each.value.global.telnet_outbound_variable}}}", null)
  lldp                          = try(each.value.global.lldp, null)
  lldp_variable                 = try("{{${each.value.global.lldp_variable}}}", null)
  nat64_tcp_timeout             = try(each.value.global.nat64_tcp_timeout, null)
  nat64_tcp_timeout_variable    = try("{{${each.value.global.nat64_tcp_timeout_variable}}}", null)
  nat64_udp_timeout             = try(each.value.global.nat64_udp_timeout, null)
  nat64_udp_timeout_variable    = try("{{${each.value.global.nat64_udp_timeout_variable}}}", null)
  rsh_rcp                       = try(each.value.global.rsh_rcp, null)
  rsh_rcp_variable              = try("{{${each.value.global.rsh_rcp_variable}}}", null)
  snmp_ifindex_persist          = try(each.value.global.snmp_ifindex_persist, null)
  snmp_ifindex_persist_variable = try("{{${each.value.global.snmp_ifindex_persist_variable}}}", null)
  source_interface              = try(each.value.global.source_interface, null)
  source_interface_variable     = try("{{${each.value.global.source_interface_variable}}}", null)
  ssh_version                   = try(each.value.global.ssh_version, null)
  ssh_version_variable          = try("{{${each.value.global.ssh_version_variable}}}", null)
  tcp_keepalives_in             = try(each.value.global.tcp_keepalives_in, null)
  tcp_keepalives_in_variable    = try("{{${each.value.global.tcp_keepalives_in_variable}}}", null)
  tcp_keepalives_out            = try(each.value.global.tcp_keepalives_out, null)
  tcp_keepalives_out_variable   = try("{{${each.value.global.tcp_keepalives_out_variable}}}", null)
  tcp_small_servers             = try(each.value.global.tcp_small_servers, null)
  tcp_small_servers_variable    = try("{{${each.value.global.tcp_small_servers_variable}}}", null)
  udp_small_servers             = try(each.value.global.udp_small_servers, null)
  udp_small_servers_variable    = try("{{${each.value.global.udp_small_servers_variable}}}", null)
  vty_line_logging              = try(each.value.global.vty_line_logging, null)
  vty_line_logging_variable     = try("{{${each.value.global.vty_line_logging_variable}}}", null)
}

resource "sdwan_system_logging_profile_parcel" "system_logging_profile_parcel" {
  for_each = {
    for sys in try(local.feature_profiles.system_profiles, {}) :
    "${sys.name}-logging" => sys
    if try(sys.logging, null) != null
  }
  name                      = try(each.value.logging.name, "${each.value.name}-logging")
  description               = try(each.value.logging.description, null)
  feature_profile_id        = sdwan_system_feature_profile.system_feature_profile[each.value.name].id
  disk_file_rotate          = try(each.value.logging.disk_file_rotate, null)
  disk_file_rotate_variable = try("{{${each.value.logging.disk_file_rotate_variable}}}", null)
  disk_file_size            = try(each.value.logging.disk_file_size, null)
  disk_file_size_variable   = try("{{${each.value.logging.disk_file_size_variable}}}", null)
  ipv4_servers = try(length(each.value.logging.ipv4_servers) == 0, true) ? null : [for server in each.value.logging.ipv4_servers : {
    hostname_ip                            = try(server.hostname_ip, null)
    hostname_ip_variable                   = try("{{${server.hostname_ip_variable}}}", null)
    priority                               = try(server.severity, null)
    priority_variable                      = try("{{${server.severity_variable}}}", null)
    source_interface                       = try(server.source_interface, null)
    source_interface_variable              = try("{{${server.source_interface_variable}}}", null)
    tls_enable                             = try(server.tls_enable, null)
    tls_enable_variable                    = try("{{${server.tls_enable_variable}}}", null)
    tls_properties_custom_profile          = try(server.tls_properties_custom_profile, null)
    tls_properties_custom_profile_variable = try("{{${server.tls_properties_custom_profile_variable}}}", null)
    tls_properties_profile                 = try(server.tls_properties_profile, null)
    tls_properties_profile_variable        = try("{{${server.tls_properties_profile_variable}}}", null)
    vpn                                    = try(server.vpn_id, null)
    vpn_variable                           = try("{{${server.vpn_id_variable}}}", null)
  }]
  ipv6_servers = try(length(each.value.logging.ipv6_servers) == 0, true) ? null : [for server in each.value.logging.ipv6_servers : {
    hostname_ip                            = try(server.hostname_ip, null)
    hostname_ip_variable                   = try("{{${server.hostname_ip_variable}}}", null)
    priority                               = try(server.severity, null)
    priority_variable                      = try("{{${server.severity_variable}}}", null)
    source_interface                       = try(server.source_interface, null)
    source_interface_variable              = try("{{${server.source_interface_variable}}}", null)
    tls_enable                             = try(server.tls_enable, null)
    tls_enable_variable                    = try("{{${server.tls_enable_variable}}}", null)
    tls_properties_custom_profile          = try(server.tls_properties_custom_profile, null)
    tls_properties_custom_profile_variable = try("{{${server.tls_properties_custom_profile_variable}}}", null)
    tls_properties_profile                 = try(server.tls_properties_profile, null)
    tls_properties_profile_variable        = try("{{${server.tls_properties_profile_variable}}}", null)
    vpn                                    = try(server.vpn_id, null)
    vpn_variable                           = try("{{${server.vpn_id_variable}}}", null)
  }]
  tls_profiles = try(length(each.value.logging.tls_profiles) == 0, true) ? null : [for profile in each.value.logging.tls_profiles : {
    cipher_suites          = try(profile.cipher_suites, null)
    cipher_suites_variable = try("{{${profile.cipher_suites_variable}}}", null)
    profile                = try(profile.name, null)
    profile_variable       = try("{{${profile.name_variable}}}", null)
    tls_version            = try(profile.tls_version, null)
    tls_version_variable   = try("{{${profile.tls_version_variable}}}", null)
  }]
}

resource "sdwan_system_mrf_profile_parcel" "system_mrf_profile_parcel" {
  for_each = {
    for sys in try(local.feature_profiles.system_profiles, {}) :
    "${sys.name}-mrf" => sys
    if try(sys.mrf, null) != null
  }
  name                         = try(each.value.mrf.name, "${each.value.name}-mrf")
  description                  = try(each.value.mrf.description, null)
  feature_profile_id           = sdwan_system_feature_profile.system_feature_profile[each.value.name].id
  enable_migration_to_mrf      = try(each.value.mrf.migration_to_mrf, null)
  migration_bgp_community      = try(each.value.mrf.migration_bgp_community, null)
  region_id                    = try(each.value.mrf.region_id, null)
  role                         = try(each.value.mrf.role, null)
  role_variable                = try("{{${each.value.mrf.role_variable}}}", null)
  secondary_region_id          = try(each.value.mrf.secondary_region_id, null)
  secondary_region_id_variable = try("{{${each.value.mrf.secondary_region_id_variable}}}", null)
}

resource "sdwan_system_ntp_profile_parcel" "system_ntp_profile_parcel" {
  for_each = {
    for sys in try(local.feature_profiles.system_profiles, {}) :
    "${sys.name}-ntp" => sys
    if try(sys.ntp, null) != null
  }
  name               = try(each.value.ntp.name, "${each.value.name}-ntp")
  description        = try(each.value.ntp.description, null)
  feature_profile_id = sdwan_system_feature_profile.system_feature_profile[each.value.name].id
  authentication_keys = try(length(each.value.ntp.authentication_keys) == 0, true) ? null : [for key in each.value.ntp.authentication_keys : {
    key_id             = try(key.id, null)
    key_id_variable    = try("{{${key.id_variable}}}", null)
    md5_value          = try(key.md5_value, null)
    md5_value_variable = try("{{${key.md5_value_variable}}}", null)
  }]
  authoritative_ntp_server          = try(each.value.ntp.authoritative_ntp_server, null)
  authoritative_ntp_server_variable = try("{{${each.value.ntp.authoritative_ntp_server_variable}}}", null)
  servers = try(length(each.value.ntp.servers) == 0, true) ? null : [for server in each.value.ntp.servers : {
    authentication_key              = try(server.authentication_key, null)
    authentication_key_variable     = try("{{${server.authentication_key_variable}}}", null)
    hostname_ip_address             = try(server.hostname_ip, null)
    hostname_ip_address_variable    = try("{{${server.hostname_ip_variable}}}", null)
    ntp_version                     = try(server.ntp_version, null)
    ntp_version_variable            = try("{{${server.ntp_version_variable}}}", null)
    prefer_this_ntp_server          = try(server.prefer, null)
    prefer_this_ntp_server_variable = try("{{${server.prefer_variable}}}", null)
    source_interface                = try(server.source_interface, null)
    source_interface_variable       = try("{{${server.source_interface_variable}}}", null)
    vpn                             = try(server.vpn_id, null)
    vpn_variable                    = try("{{${server.vpn_id_variable}}}", null)
  }]
  source_interface          = try(each.value.ntp.authoritative_ntp_server_source_interface, null)
  source_interface_variable = try("{{${each.value.ntp.authoritative_ntp_server_source_interface_variable}}}", null)
  stratum                   = try(each.value.ntp.authoritative_ntp_server_stratum, null)
  stratum_variable          = try("{{${each.value.ntp.authoritative_ntp_server_stratum_variable}}}", null)
  trusted_keys              = try(each.value.ntp.trusted_keys, null)
  trusted_keys_variable     = try("{{${each.value.ntp.trusted_keys_variable}}}", null)
}

resource "sdwan_transport_management_vpn_profile_parcel" "transport_management_vpn_profile_parcel" {
  for_each = {
    for transport in try(local.feature_profiles.transport_profiles, {}) :
    "${transport.name}-management_vpn" => transport
    if lookup(transport, "management_vpn", null) != null
  }
  name                                     = each.value.management_vpn.name
  description                              = try(each.value.management_vpn.description, null)
  feature_profile_id                       = sdwan_transport_feature_profile.transport_feature_profile[each.value.name].id
  basic_configuration_description          = try(each.value.management_vpn.vpn_description, null)
  basic_configuration_description_variable = try("{{${each.value.management_vpn.vpn_description_variable}}}", null)
  ipv4_static_routes = try(length(each.value.management_vpn.ipv4_static_routes) == 0, true) ? null : [for route in each.value.management_vpn.ipv4_static_routes : {
    administrative_distance          = try(route.administrative_distance, null)
    administrative_distance_variable = try("{{${route.administrative_distance_variable}}}", null)
    gateway                          = try(route.gateway, "nextHop")
    next_hops = try(length(route.next_hops) == 0, true) ? null : [for nh in route.next_hops : {
      address                          = try(nh.address, null)
      address_variable                 = try("{{${nh.address_variable}}}", null)
      administrative_distance          = try(nh.administrative_distance, null)
      administrative_distance_variable = try("{{${nh.administrative_distance_variable}}}", null)
    }]
    network_address          = try(route.network_address, null)
    network_address_variable = try("{{${route.network_address_variable}}}", null)
    subnet_mask              = try(route.subnet_mask, null)
    subnet_mask_variable     = try("{{${route.subnet_mask_variable}}}", null)
  }]
  ipv6_static_routes = try(length(each.value.management_vpn.ipv6_static_routes) == 0, true) ? null : [for route in each.value.management_vpn.ipv6_static_routes : {
    nat = try(route.nat, null)
    next_hops = try(length(route.next_hops) == 0, true) ? null : [for nh in route.next_hops : {
      address                          = try(nh.address, null)
      address_variable                 = try("{{${nh.address_variable}}}", null)
      administrative_distance          = try(nh.administrative_distance, null)
      administrative_distance_variable = try("{{${nh.administrative_distance_variable}}}", null)
    }]
    null0           = try(route.null0, null)
    prefix          = try(route.prefix, null)
    prefix_variable = try("{{${route.prefix_variable}}}", null)
  }]
  new_host_mappings = try(length(each.value.management_vpn.host_mappings) == 0, true) ? null : [for host in each.value.management_vpn.host_mappings : {
    host_name                     = try(host.hostname, null)
    host_name_variable            = try("{{${host.hostname_variable}}}", null)
    list_of_ip_addresses          = try(host.ips, null)
    list_of_ip_addresses_variable = try("{{${host.ips_variable}}}", null)
  }]
  primary_dns_address_ipv4            = try(each.value.management_vpn.ipv4_primary_dns_address, null)
  primary_dns_address_ipv4_variable   = try("{{${each.value.management_vpn.ipv4_primary_dns_address_variable}}}", null)
  primary_dns_address_ipv6            = try(each.value.management_vpn.ipv6_primary_dns_address, null)
  primary_dns_address_ipv6_variable   = try("{{${each.value.management_vpn.ipv6_primary_dns_address_variable}}}", null)
  secondary_dns_address_ipv4          = try(each.value.management_vpn.ipv4_secondary_dns_address, null)
  secondary_dns_address_ipv4_variable = try("{{${each.value.management_vpn.ipv4_secondary_dns_address_variable}}}", null)
  secondary_dns_address_ipv6          = try(each.value.management_vpn.ipv6_secondary_dns_address, null)
  secondary_dns_address_ipv6_variable = try("{{${each.value.management_vpn.ipv6_secondary_dns_address_variable}}}", null)
}

resource "sdwan_transport_wan_vpn_profile_parcel" "transport_wan_vpn_profile_parcel" {
  for_each = {
    for transport in try(local.feature_profiles.transport_profiles, {}) :
    "${transport.name}-wan_vpn" => transport
    if lookup(transport, "wan_vpn", null) != null
  }
  name                         = each.value.wan_vpn.name
  description                  = try(each.value.wan_vpn.description, null)
  feature_profile_id           = sdwan_transport_feature_profile.transport_feature_profile[each.value.name].id
  enhance_ecmp_keying          = try(each.value.wan_vpn.enhance_ecmp_keying, null)
  enhance_ecmp_keying_variable = try("{{${each.value.wan_vpn.enhance_ecmp_keying_variable}}}", null)
  ipv4_static_routes = try(length(each.value.wan_vpn.ipv4_static_routes) == 0, true) ? null : [for route in each.value.wan_vpn.ipv4_static_routes : {
    administrative_distance          = try(route.administrative_distance, null)
    administrative_distance_variable = try("{{${route.administrative_distance_variable}}}", null)
    gateway                          = try(route.gateway, "nextHop")
    next_hops = try(length(route.next_hops) == 0, true) ? null : [for nh in route.next_hops : {
      address                          = try(nh.address, null)
      address_variable                 = try("{{${nh.address_variable}}}", null)
      administrative_distance          = try(nh.administrative_distance, null)
      administrative_distance_variable = try("{{${nh.administrative_distance_variable}}}", null)
    }]
    network_address          = try(route.network_address, null)
    network_address_variable = try("{{${route.network_address_variable}}}", null)
    subnet_mask              = try(route.subnet_mask, null)
    subnet_mask_variable     = try("{{${route.subnet_mask_variable}}}", null)
  }]
  ipv6_static_routes = try(length(each.value.wan_vpn.ipv6_static_routes) == 0, true) ? null : [for route in each.value.wan_vpn.ipv6_static_routes : {
    nat = try(route.nat, null)
    next_hops = try(length(route.next_hops) == 0, true) ? null : [for nh in route.next_hops : {
      address                          = try(nh.address, null)
      address_variable                 = try("{{${nh.address_variable}}}", null)
      administrative_distance          = try(nh.administrative_distance, null)
      administrative_distance_variable = try("{{${nh.administrative_distance_variable}}}", null)
    }]
    null0           = try(route.null0, null)
    prefix          = try(route.prefix, null)
    prefix_variable = try("{{${route.prefix_variable}}}", null)
  }]
  nat_64_v4_pools = try(length(each.value.wan_vpn.nat_64_v4_pools) == 0, true) ? null : [for pool in each.value.wan_vpn.nat_64_v4_pools : {
    nat64_v4_pool_name                 = try(pool.name, null)
    nat64_v4_pool_name_variable        = try("{{${pool.name_variable}}}", null)
    nat64_v4_pool_overload             = try(pool.overload, null)
    nat64_v4_pool_overload_variable    = try("{{${pool.overload_variable}}}", null)
    nat64_v4_pool_range_end            = try(pool.range_end, null)
    nat64_v4_pool_range_end_variable   = try("{{${pool.range_end_variable}}}", null)
    nat64_v4_pool_range_start          = try(pool.range_start, null)
    nat64_v4_pool_range_start_variable = try("{{${pool.range_start_variable}}}", null)
  }]
  new_host_mappings = try(length(each.value.wan_vpn.host_mappings) == 0, true) ? null : [for host in each.value.wan_vpn.host_mappings : {
    host_name                     = try(host.hostname, null)
    host_name_variable            = try("{{${host.hostname_variable}}}", null)
    list_of_ip_addresses          = try(host.ips, null)
    list_of_ip_addresses_variable = try("{{${host.ips_variable}}}", null)
  }]
  primary_dns_address_ipv4            = try(each.value.wan_vpn.ipv4_primary_dns_address, null)
  primary_dns_address_ipv4_variable   = try("{{${each.value.wan_vpn.ipv4_primary_dns_address_variable}}}", null)
  primary_dns_address_ipv6            = try(each.value.wan_vpn.ipv6_primary_dns_address, null)
  primary_dns_address_ipv6_variable   = try("{{${each.value.wan_vpn.ipv6_primary_dns_address_variable}}}", null)
  secondary_dns_address_ipv4          = try(each.value.wan_vpn.ipv4_secondary_dns_address, null)
  secondary_dns_address_ipv4_variable = try("{{${each.value.wan_vpn.ipv4_secondary_dns_address_variable}}}", null)
  secondary_dns_address_ipv6          = try(each.value.wan_vpn.ipv6_secondary_dns_address, null)
  secondary_dns_address_ipv6_variable = try("{{${each.value.wan_vpn.ipv6_secondary_dns_address_variable}}}", null)
  services = try(length(each.value.wan_vpn.services) == 0, true) ? null : [for service in each.value.wan_vpn.services : {
    service_type = service
  }]
  vpn = 0
}
