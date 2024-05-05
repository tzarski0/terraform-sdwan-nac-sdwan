resource "sdwan_system_aaa_profile_parcel" "system_aaa_profile_parcel" {
  for_each = {
    for sys in try(local.feature_profiles.system_profiles, {}) :
    "${sys.name}-aaa" => sys
    if lookup(sys, "aaa", null) != null
  }
  name                      = each.value.aaa.name
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
    if lookup(sys, "banner", null) != null
  }
  name               = each.value.banner.name
  description        = try(each.value.banner.description, null)
  feature_profile_id = sdwan_system_feature_profile.system_feature_profile[each.value.name].id
  login              = try(each.value.banner.login, null)
  login_variable     = try("{{${each.value.banner.login_variable}}}", null)
  motd               = try(each.value.banner.motd, null)
  motd_variable      = try("{{${each.value.banner.motd_variable}}}", null)
}

resource "sdwan_system_basic_profile_parcel" "system_basic_profile_parcel" {
  for_each = {
    for sys in try(local.feature_profiles.system_profiles, {}) :
    "${sys.name}-basic" => sys
    if lookup(sys, "basic", null) != null
  }
  name                                = each.value.basic.name
  description                         = try(each.value.basic.description, null)
  feature_profile_id                  = sdwan_system_feature_profile.system_feature_profile[each.value.name].id
  admin_tech_on_failure               = try(each.value.basic.admin_tech_on_failure, null)
  admin_tech_on_failure_variable      = try("{{${each.value.basic.admin_tech_on_failure_variable}}}", null)
  affinity_group_number               = try(each.value.basic.affinity_group_number, null)
  affinity_group_number_variable      = try("{{${each.value.basic.affinity_group_number_variable}}}", null)
  affinity_group_preferences          = try(each.value.basic.affinity_group_preferences, null)
  affinity_group_preferences_variable = try("{{${each.value.basic.affinity_group_preferences_variable}}}", null)
  affinity_per_vrfs = try(length(each.value.basic.affinity_per_vrfs) == 0, true) ? null : [for a in each.value.basic.affinity_per_vrfs : {
    affinity_group_number          = try(a.affinity_group_number, null)
    affinity_group_number_variable = try("{{${a.affinity_group_number_variable}}}", null)
    vrf_range                      = try(a.vrf_range, null)
    vrf_range_variable             = try("{{${a.vrf_range_variable}}}", null)
  }]
  affinity_preference_auto            = try(each.value.basic.affinity_preference_auto, null)
  affinity_preference_auto_variable   = try("{{${each.value.basic.affinity_preference_auto_variable}}}", null)
  config_description                  = try(each.value.basic.system_description, null)
  config_description_variable         = try("{{${each.value.basic.system_description_variable}}}", null)
  console_baud_rate                   = try(each.value.basic.console_baud_rate, null)
  console_baud_rate_variable          = try("{{${each.value.basic.console_baud_rate_variable}}}", null)
  control_session_pps                 = try(each.value.basic.control_session_pps, null)
  control_session_pps_variable        = try("{{${each.value.basic.control_session_pps_variable}}}", null)
  controller_groups                   = try(each.value.basic.controller_groups, null)
  controller_groups_variable          = try("{{${each.value.basic.controller_groups_variable}}}", null)
  device_groups                       = try(each.value.basic.device_groups, null)
  device_groups_variable              = try("{{${each.value.basic.device_groups_variable}}}", null)
  enhanced_app_aware_routing          = try(each.value.basic.enhanced_app_aware_routing, null)
  enhanced_app_aware_routing_variable = try("{{${each.value.basic.enhanced_app_aware_routing_variable}}}", null)
  gps_geo_fencing_enable              = try(each.value.basic.geo_fencing_enable, null)
  gps_geo_fencing_range               = try(each.value.basic.geo_fencing_range, null)
  gps_geo_fencing_range_variable      = try("{{${each.value.basic.geo_fencing_range_variable}}}", null)
  gps_latitude                        = try(each.value.basic.latitude, null)
  gps_latitude_variable               = try("{{${each.value.basic.latitude_variable}}}", null)
  gps_longitude                       = try(each.value.basic.longitude, null)
  gps_longitude_variable              = try("{{${each.value.basic.longitude_variable}}}", null)
  gps_sms_enable                      = try(each.value.basic.geo_fencing_sms_enable, null)
  gps_sms_mobile_numbers = try(length(each.value.basic.geo_fencing_sms_mobile_numbers) == 0, true) ? null : [for n in each.value.basic.geo_fencing_sms_phone_numbers : {
    number          = try(n.number, null)
    number_variable = try("{{${n.number_variable}}}", null)
  }]
  idle_timeout                    = try(each.value.basic.idle_timeout, null)
  idle_timeout_variable           = try("{{${each.value.basic.idle_timeout_variable}}}", null)
  location                        = try(each.value.basic.location, null)
  location_variable               = try("{{${each.value.basic.location_variable}}}", null)
  max_omp_sessions                = try(each.value.basic.max_omp_sessions, null)
  max_omp_sessions_variable       = try("{{${each.value.basic.max_omp_sessions_variable}}}", null)
  multi_tenant                    = try(each.value.basic.multitenant, null)
  multi_tenant_variable           = try("{{${each.value.basic.multitenant_variable}}}", null)
  on_demand_enable                = try(each.value.basic.on_demand_tunnel, null)
  on_demand_enable_variable       = try("{{${each.value.basic.on_demand_tunnel_variable}}}", null)
  on_demand_idle_timeout          = try(each.value.basic.on_demand_tunnel_idle_timeout, null)
  on_demand_idle_timeout_variable = try("{{${each.value.basic.on_demand_tunnel_idle_timeout_variable}}}", null)
  overlay_id                      = try(each.value.basic.overlay_id, null)
  overlay_id_variable             = try("{{${each.value.basic.overlay_id_variable}}}", null)
  port_hopping                    = try(each.value.basic.port_hopping, null)
  port_hopping_variable           = try("{{${each.value.basic.port_hopping_variable}}}", null)
  port_offset                     = try(each.value.basic.port_offset, null)
  port_offset_variable            = try("{{${each.value.basic.port_offset_variable}}}", null)
  site_types                      = try(each.value.basic.site_types, null)
  site_types_variable             = try("{{${each.value.basic.site_types_variable}}}", null)
  timezone                        = try(each.value.basic.timezone, null)
  timezone_variable               = try("{{${each.value.basic.timezone_variable}}}", null)
  track_default_gateway           = try(each.value.basic.track_default_gateway, null)
  track_default_gateway_variable  = try("{{${each.value.basic.track_default_gateway_variable}}}", null)
  track_interface_tag             = try(each.value.basic.track_interface_tag, null)
  track_interface_tag_variable    = try("{{${each.value.basic.track_interface_tag_variable}}}", null)
  track_transport                 = try(each.value.basic.track_transport, null)
  track_transport_variable        = try("{{${each.value.basic.track_transport_variable}}}", null)
  transport_gateway               = try(each.value.basic.transport_gateway, null)
  transport_gateway_variable      = try("{{${each.value.basic.transport_gateway_variable}}}", null)
}

resource "sdwan_system_bfd_profile_parcel" "system_bfd_profile_parcel" {
  for_each = {
    for sys in try(local.feature_profiles.system_profiles, {}) :
    "${sys.name}-bfd" => sys
    if lookup(sys, "bfd", null) != null
  }
  name               = each.value.bfd.name
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
    if lookup(sys, "flexible_port_speed", null) != null
  }
  name               = each.value.flexible_port_speed.name
  description        = try(each.value.flexible_port_speed.description, null)
  feature_profile_id = sdwan_system_feature_profile.system_feature_profile[each.value.name].id
  port_type          = try(each.value.flexible_port_speed.port_type, null)
  port_type_variable = try("{{${each.value.flexible_port_speed.port_type_variable}}}", null)
}

resource "sdwan_system_global_profile_parcel" "system_global_profile_parcel" {
  for_each = {
    for sys in try(local.feature_profiles.system_profiles, {}) :
    "${sys.name}-global" => sys
    if lookup(sys, "global", null) != null
  }
  name                          = each.value.global.name
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

resource "sdwan_system_mrf_profile_parcel" "system_mrf_profile_parcel" {
  for_each = {
    for sys in try(local.feature_profiles.system_profiles, {}) :
    "${sys.name}-mrf" => sys
    if lookup(sys, "mrf", null) != null
  }
  name                         = each.value.mrf.name
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

resource "sdwan_system_omp_profile_parcel" "system_omp_profile_parcel" {
  for_each = {
    for sys in try(local.feature_profiles.system_profiles, {}) :
    "${sys.name}-omp" => sys
    if lookup(sys, "omp", null) != null
  }
  name                                 = each.value.omp.name
  description                          = try(each.value.omp.description, null)
  feature_profile_id                   = sdwan_system_feature_profile.system_feature_profile[each.value.name].id
  advertise_ipv4_bgp                   = try(each.value.omp.advertise_ipv4_bgp, null)
  advertise_ipv4_bgp_variable          = try("{{${each.value.omp.advertise_ipv4_bgp_variable}}}", null)
  advertise_ipv4_connected             = try(each.value.omp.advertise_ipv4_connected, null)
  advertise_ipv4_connected_variable    = try("{{${each.value.omp.advertise_ipv4_connected_variable}}}", null)
  advertise_ipv4_eigrp                 = try(each.value.omp.advertise_ipv4_eigrp, null)
  advertise_ipv4_eigrp_variable        = try("{{${each.value.omp.advertise_ipv4_eigrp_variable}}}", null)
  advertise_ipv4_isis                  = try(each.value.omp.advertise_ipv4_isis, null)
  advertise_ipv4_isis_variable         = try("{{${each.value.omp.advertise_ipv4_isis_variable}}}", null)
  advertise_ipv4_lisp                  = try(each.value.omp.advertise_ipv4_lisp, null)
  advertise_ipv4_lisp_variable         = try("{{${each.value.omp.advertise_ipv4_lisp_variable}}}", null)
  advertise_ipv4_ospf                  = try(each.value.omp.advertise_ipv4_ospf, null)
  advertise_ipv4_ospf_v3               = try(each.value.omp.advertise_ipv4_ospf_v3, null)
  advertise_ipv4_ospf_v3_variable      = try("{{${each.value.omp.advertise_ipv4_ospf_v3_variable}}}", null)
  advertise_ipv4_ospf_variable         = try("{{${each.value.omp.advertise_ipv4_ospf_variable}}}", null)
  advertise_ipv4_static                = try(each.value.omp.advertise_ipv4_static, null)
  advertise_ipv4_static_variable       = try("{{${each.value.omp.advertise_ipv4_static_variable}}}", null)
  advertise_ipv6_bgp                   = try(each.value.omp.advertise_ipv6_bgp, null)
  advertise_ipv6_bgp_variable          = try("{{${each.value.omp.advertise_ipv6_bgp_variable}}}", null)
  advertise_ipv6_connected             = try(each.value.omp.advertise_ipv6_connected, null)
  advertise_ipv6_connected_variable    = try("{{${each.value.omp.advertise_ipv6_connected_variable}}}", null)
  advertise_ipv6_eigrp                 = try(each.value.omp.advertise_ipv6_eigrp, null)
  advertise_ipv6_eigrp_variable        = try("{{${each.value.omp.advertise_ipv6_eigrp_variable}}}", null)
  advertise_ipv6_isis                  = try(each.value.omp.advertise_ipv6_isis, null)
  advertise_ipv6_isis_variable         = try("{{${each.value.omp.advertise_ipv6_isis_variable}}}", null)
  advertise_ipv6_lisp                  = try(each.value.omp.advertise_ipv6_lisp, null)
  advertise_ipv6_lisp_variable         = try("{{${each.value.omp.advertise_ipv6_lisp_variable}}}", null)
  advertise_ipv6_ospf                  = try(each.value.omp.advertise_ipv6_ospf, null)
  advertise_ipv6_ospf_variable         = try("{{${each.value.omp.advertise_ipv6_ospf_variable}}}", null)
  advertise_ipv6_static                = try(each.value.omp.advertise_ipv6_static, null)
  advertise_ipv6_static_variable       = try("{{${each.value.omp.advertise_ipv6_static_variable}}}", null)
  advertisement_interval               = try(each.value.omp.advertisement_interval, null)
  advertisement_interval_variable      = try("{{${each.value.omp.advertisement_interval_variable}}}", null)
  ecmp_limit                           = try(each.value.omp.ecmp_limit, null)
  ecmp_limit_variable                  = try("{{${each.value.omp.ecmp_limit_variable}}}", null)
  eor_timer                            = try(each.value.omp.eor_timer, null)
  eor_timer_variable                   = try("{{${each.value.omp.eor_timer_variable}}}", null)
  graceful_restart                     = try(each.value.omp.graceful_restart, null)
  graceful_restart_timer               = try(each.value.omp.graceful_restart_timer, null)
  graceful_restart_timer_variable      = try("{{${each.value.omp.graceful_restart_timer_variable}}}", null)
  graceful_restart_variable            = try("{{${each.value.omp.graceful_restart_variable}}}", null)
  holdtime                             = try(each.value.omp.holdtime, null)
  holdtime_variable                    = try("{{${each.value.omp.holdtime_variable}}}", null)
  ignore_region_path_length            = try(each.value.omp.ignore_region_path_length, null)
  ignore_region_path_length_variable   = try("{{${each.value.omp.ignore_region_path_length_variable}}}", null)
  omp_admin_distance_ipv4              = try(each.value.omp.omp_admin_distance_ipv4, null)
  omp_admin_distance_ipv4_variable     = try("{{${each.value.omp.omp_admin_distance_ipv4_variable}}}", null)
  omp_admin_distance_ipv6              = try(each.value.omp.omp_admin_distance_ipv6, null)
  omp_admin_distance_ipv6_variable     = try("{{${each.value.omp.omp_admin_distance_ipv6_variable}}}", null)
  overlay_as                           = try(each.value.omp.overlay_as, null)
  overlay_as_variable                  = try("{{${each.value.omp.overlay_as_variable}}}", null)
  paths_advertised_per_prefix          = try(each.value.omp.paths_advertised_per_prefix, null)
  paths_advertised_per_prefix_variable = try("{{${each.value.omp.paths_advertised_per_prefix_variable}}}", null)
  shutdown                             = try(each.value.omp.shutdown, null)
  shutdown_variable                    = try("{{${each.value.omp.shutdown_variable}}}", null)
  site_types                           = try(each.value.omp.site_types, null)
  site_types_variable                  = try("{{${each.value.omp.site_types_variable}}}", null)
  transport_gateway                    = try(each.value.omp.transport_gateway, null)
  transport_gateway_variable           = try("{{${each.value.omp.transport_gateway_variable}}}", null)
}

resource "sdwan_system_performance_monitoring_profile_parcel" "system_performance_monitoring_profile_parcel" {
  for_each = {
    for sys in try(local.feature_profiles.system_profiles, {}) :
    "${sys.name}-performance_monitoring" => sys
    if lookup(sys, "performance_monitoring", null) != null
  }
  name                        = each.value.performance_monitoring.name
  description                 = try(each.value.performance_monitoring.description, null)
  feature_profile_id          = sdwan_system_feature_profile.system_feature_profile[each.value.name].id
  app_perf_monitor_app_group  = try(each.value.performance_monitoring.app_perf_monitor_app_groups, null)
  app_perf_monitor_enabled    = try(each.value.performance_monitoring.app_perf_monitor_enabled, null)
  event_driven_config_enabled = try(each.value.performance_monitoring.event_driven_config_enabled, null)
  event_driven_events         = try(each.value.performance_monitoring.event_driven_events, null)
  monitoring_config_enabled   = try(each.value.performance_monitoring.monitoring_config_enabled, null)
  monitoring_config_interval  = try(each.value.performance_monitoring.monitoring_config_interval, null)
}

resource "sdwan_system_security_profile_parcel" "system_security_profile_parcel" {
  for_each = {
    for sys in try(local.feature_profiles.system_profiles, {}) :
    "${sys.name}-security" => sys
    if lookup(sys, "security", null) != null
  }
  name                                 = each.value.security.name
  description                          = try(each.value.security.description, null)
  feature_profile_id                   = sdwan_system_feature_profile.system_feature_profile[each.value.name].id
  anti_replay_window                   = try(each.value.security.anti_replay_window, null)
  anti_replay_window_variable          = try("{{${each.value.anti_replay_window_variable}}}", null)
  extended_anti_replay_window          = try(each.value.security.extended_anti_replay_window, null)
  extended_anti_replay_window_variable = try("{{${each.value.security.extended_anti_replay_window_variable}}}", null)
  integrity_type                       = try(each.value.security.integrity_types, null)
  integrity_type_variable              = try("{{${each.value.security.integrity_types_variable}}}", null)
  ipsec_pairwise_keying                = try(each.value.security.ipsec_pairwise_keying, null)
  ipsec_pairwise_keying_variable       = try("{{${each.value.security.ipsec_pairwise_keying_variable}}}", null)
  keychains = try(length(each.value.security.key_chains) == 0, true) ? null : [for key_chain in each.value.security.key_chains : {
    key_chain_name = key_chain.name
    key_id         = key_chain.key_id
  }]
  keys = try(length(each.value.security.keys) == 0, true) ? null : [for key in each.value.security.keys : {
    accept_ao_mismatch              = try(key.accept_ao_mismatch, null)
    accept_ao_mismatch_variable     = try("{{${key.accept_ao_mismatch_variable}}}", null)
    accept_life_time_duration       = try(key.accept_life_time_duration, null)
    accept_life_time_exact          = try(key.accept_life_time_exact, null)
    accept_life_time_infinite       = try(key.accept_life_time_infinite, null)
    accept_life_time_local          = try(key.accept_life_time_local, null)
    accept_life_time_local_variable = try("{{${key.accept_life_time_local_variable}}}", null)
    accept_life_time_start_epoch    = try(key.accept_life_time_start_epoch, null)
    crypto_algorithm                = key.crypto_algorithm
    id                              = key.id
    include_tcp_options             = try(key.include_tcp_options, null)
    include_tcp_options_variable    = try("{{${key.include_tcp_options_variable}}}", null)
    key_string                      = try(key.key_string, null)
    key_string_variable             = try("{{${key.key_string_variable}}}", null)
    name                            = key.key_chain_name
    receiver_id                     = try(key.receiver_id, null)
    receiver_id_variable            = try("{{${key.receiver_id_variable}}}", null)
    send_id                         = try(key.send_id, null)
    send_id_variable                = try("{{${key.send_id_variable}}}", null)
    send_life_time_duration         = try(key.send_life_time_duration, null)
    send_life_time_exact            = try(key.send_life_time_exact, null)
    send_life_time_infinite         = try(key.send_life_time_infinite, null)
    send_life_time_local            = try(key.send_life_time_local, null)
    send_life_time_local_variable   = try("{{${key.send_life_time_local_variable}}}", null)
    send_life_time_start_epoch      = try(key.send_life_time_start_epoch, null)
  }]
  rekey          = try(each.value.security.rekey_time, null)
  rekey_variable = try("{{${each.value.security.rekey_time_variable}}}", null)
}

resource "sdwan_system_snmp_profile_parcel" "system_snmp_profile_parcel" {
  for_each = {
    for sys in try(local.feature_profiles.system_profiles, {}) :
    "${sys.name}-snmp" => sys
    if lookup(sys, "snmp", null) != null
  }
  name               = each.value.snmp.name
  description        = try(each.value.snmp.description, null)
  feature_profile_id = sdwan_system_feature_profile.system_feature_profile[each.value.name].id
  communities = try(length(each.value.snmp.communities) == 0, true) ? null : [for c in each.value.snmp.communities : {
    authorization          = try(c.authorization, null)
    authorization_variable = try("{{${c.authorization_variable}}}", null)
    name                   = c.name
    user_label             = c.user_label
    view                   = try(c.view, null)
    view_variable          = try("{{${c.view_variable}}}", null)
  }]
  contact_person          = try(each.value.snmp.contact_person, null)
  contact_person_variable = try("{{${each.value.snmp.contact_person_variable}}}", null)
  groups = try(length(each.value.snmp.groups) == 0, true) ? null : [for group in each.value.snmp.groups : {
    name           = group.name
    security_level = group.security_level
    view           = try(group.view, null)
    view_variable  = try("{{${group.view.view_variable}}}", null)
  }]
  location_of_device          = try(each.value.snmp.location, null)
  location_of_device_variable = try("{{${each.value.snmp.location_variable}}}", null)
  shutdown                    = try(each.value.snmp.shutdown, null)
  shutdown_variable           = try("{{${each.value.snmp.shutdown_variable}}}", null)
  trap_target_servers = try(length(each.value.snmp.trap_target_servers) == 0, true) ? null : [for server in each.value.snmp.trap_target_servers : {
    ip                        = try(server.ip, null)
    ip_variable               = try("{{${server.ip_variable}}}", null)
    port                      = try(server.port, null)
    port_variable             = try("{{${server.port_variable}}}", null)
    source_interface          = try(server.source_interface, null)
    source_interface_variable = try("{{${server.source_interface_variable}}}", null)
    user                      = try(server.user, null)
    user_label                = try(server.user_label, null)
    user_variable             = try("{{${server.user_variable}}}", null)
    vpn_id                    = try(server.vpn_id, null)
    vpn_id_variable           = try("{{${server.vpn_id_variable}}}", null)
  }]
  users = try(length(each.value.snmp.users) == 0, true) ? null : [for user in each.value.snmp.users : {
    authentication_password          = try(user.authentication_password, null)
    authentication_password_variable = try("{{${user.authentication_password_variable}}}", null)
    authentication_protocol          = try(user.authentication_protocol, null)
    authentication_protocol_variable = try("{{${user.authentication_protocol_variable}}}", null)
    group                            = try(user.group, null)
    group_variable                   = try("{{${user.group_variable}}}", null)
    name                             = user.name
    privacy_password                 = try(user.privacy_password, null)
    privacy_password_variable        = try("{{${user.privacy_password_variable}}}", null)
    privacy_protocol                 = try(user.privacy_protocol, null)
    privacy_protocol_variable        = try("{{${user.privacy_protocol_variable}}}", null)
  }]
  views = try(length(each.value.snmp.views) == 0, true) ? null : [for view in each.value.snmp.views : {
    name = view.name
    oids = try(length(view.oids) == 0, true) ? null : [for oid in view.oids : {
      exclude          = try(oid.exclude, null)
      exclude_variable = try("{{${oid.exclude_variable}}}", null)
      id               = try(oid.id, null)
      id_variable      = try("{{${oid.id_variable}}}", null)
    }]
  }]
}

resource "sdwan_transport_routing_bgp_profile_parcel" "transport_routing_bgp_profile_parcel" {
  for_each = {
    for transport in try(local.feature_profiles.transport_profiles, {}) :
    "${transport.name}-bgp" => transport
    if lookup(transport, "bgp", null) != null
  }
  name                              = each.value.bgp.name
  description                       = try(each.value.bgp.description, null)
  feature_profile_id                = sdwan_transport_feature_profile.transport_feature_profile[each.value.name].id
  always_compare_med                = try(each.value.bgp.always_compare_med, null)
  always_compare_med_variable       = try("{{${each.value.bgp.always_compare_med_variable}}}", null)
  as_number                         = try(each.value.bgp.as_number, null)
  as_number_variable                = try("{{${each.value.bgp.as_number_variable}}}", null)
  compare_router_id                 = try(each.value.bgp.compare_router_id, null)
  compare_router_id_variable        = try("{{${each.value.bgp.compare_router_id_variable}}}", null)
  deterministic_med                 = try(each.value.bgp.deterministic_med, null)
  deterministic_med_variable        = try("{{${each.value.bgp.deterministic_med_variable}}}", null)
  external_routes_distance          = try(each.value.bgp.external_routes_distance, null)
  external_routes_distance_variable = try("{{${each.value.bgp.external_routes_distance_variable}}}", null)
  hold_time                         = try(each.value.bgp.hold_time, null)
  hold_time_variable                = try("{{${each.value.bgp.hold_time_variable}}}", null)
  internal_routes_distance          = try(each.value.bgp.internal_routes_distance, null)
  internal_routes_distance_variable = try("{{${each.value.bgp.internal_routes_distance_variable}}}", null)
  ipv4_aggregate_addresses = try(length(each.value.bgp.ipv4_aggregate_addresses) == 0, true) ? null : [for a in each.value.bgp.ipv4_aggregate_addresses : {
    as_set_path              = try(a.as_set_path, null)
    as_set_path_variable     = try("{{${a.as_set_path_variable}}}", null)
    network_address          = try(a.network_address, null)
    network_address_variable = try("{{${a.network_address_variable}}}", null)
    subnet_mask              = try(a.subnet_mask, null)
    subnet_mask_variable     = try("{{${a.subnet_mask_variable}}}", null)
    summary_only             = try(a.summary_only, null)
    summary_only_variable    = try("{{${a.summary_only_variable}}}", null)
  }]
  ipv4_eibgp_maximum_paths          = try(each.value.bgp.ipv4_eibgp_maximum_paths, null)
  ipv4_eibgp_maximum_paths_variable = try("{{${each.value.bgp.ipv4_eibgp_maximum_paths_variable}}}", null)
  ipv4_neighbors = try(length(each.value.bgp.ipv4_neighbors) == 0, true) ? null : [for neighbor in each.value.bgp.ipv4_neighbors : {
    address          = try(neighbor.address, null)
    address_variable = try("{{${neighbor.address_variable}}}", null)
    address_families = try(length(neighbor.address_families) == 0, true) ? null : [for address_family in neighbor.address_families : {
      family_type = address_family.family_type
      // in_route_policy_id (in_route_policy) TO BE ADDED AFTER RPL IS IMPLEMENTED
      max_number_of_prefixes          = try(address_family.maximum_prefixes_number, null)
      max_number_of_prefixes_variable = try("{{${address_family.maximum_prefixes_number_variable}}}", null)
      // out_route_policy_id (out_route_policy) TO BE ADDED AFTER RPL IS IMPLEMENTED
      policy_type               = try(address_family.maximum_prefixes_reach_policy, null)
      restart_interval          = try(address_family.maximum_prefixes_restart_interval, null)
      restart_interval_variable = try("{{${address_family.maximum_prefixes_restart_interval_variable}}}", null)
      threshold                 = try(address_family.maximum_prefixes_threshold, null)
      threshold_variable        = try("{{${address_family.maximum_prefixes_threshold_variable}}}", null)
    }]
    allowas_in_number                = try(neighbor.allowas_in_number, null)
    allowas_in_number_variable       = try("{{${neighbor.allowas_in_number_variable}}}", null)
    as_override                      = try(neighbor.as_override, null)
    as_override_variable             = try("{{${neighbor.as_override_variable}}}", null)
    description                      = try(neighbor.description, null)
    description_variable             = try("{{${neighbor.description_variable}}}", null)
    ebgp_multihop                    = try(neighbor.ebgp_multihop, null)
    ebgp_multihop_variable           = try("{{${neighbor.ebgp_multihop_variable}}}", null)
    explicit_null                    = try(neighbor.send_label_explicit_null, null)
    explicit_null_variable           = try("{{${neighbor.send_label_explicit_null_variable}}}", null)
    hold_time                        = try(neighbor.hold_time, null)
    hold_time_variable               = try("{{${neighbor.hold_time_variable}}}", null)
    keepalive_time                   = try(neighbor.keepalive_time, null)
    keepalive_time_variable          = try("{{${neighbor.keepalive_time_variable}}}", null)
    local_as                         = try(neighbor.local_as, null)
    local_as_variable                = try("{{${neighbor.local_as_variable}}}", null)
    next_hop_self                    = try(neighbor.next_hop_self, null)
    next_hop_self_variable           = try("{{${neighbor.next_hop_self_variable}}}", null)
    password                         = try(neighbor.password, null)
    password_variable                = try("{{${neighbor.password_variable}}}", null)
    remote_as                        = try(neighbor.remote_as, null)
    remote_as_variable               = try("{{${neighbor.remote_as_variable}}}", null)
    send_community                   = try(neighbor.send_community, null)
    send_community_variable          = try("{{${neighbor.send_community_variable}}}", null)
    send_extended_community          = try(neighbor.send_extended_community, null)
    send_extended_community_variable = try("{{${neighbor.send_extended_community_variable}}}", null)
    send_label                       = try(neighbor.send_label, null)
    shutdown                         = try(neighbor.shutdown, null)
    shutdown_variable                = try("{{${neighbor.shutdown_variable}}}", null)
    update_source_interface          = try(neighbor.source_interface, null)
    update_source_interface_variable = try("{{${neighbor.source_interface_variable}}}", null)
  }]
  ipv4_networks = try(length(each.value.bgp.ipv4_networks) == 0, true) ? null : [for network in each.value.bgp.ipv4_networks : {
    network_address          = try(network.network_address, null)
    network_address_variable = try("{{${network.network_address_variable}}}", null)
    subnet_mask              = try(network.subnet_mask, null)
    subnet_mask_variable     = try("{{${network.subnet_mask_variable}}}", null)
  }]
  ipv4_originate          = try(each.value.bgp.ipv4_default_originate, null)
  ipv4_originate_variable = try("{{${each.value.bgp.ipv4_default_originate_variable}}}", null)
  ipv4_redistributes = try(length(each.value.bgp.ipv4_redistributes) == 0, true) ? null : [for redistribute in each.value.bgp.ipv4_redistributes : {
    protocol          = try(redistribute.protocol, null)
    protocol_variable = try("{{${redistribute.protocol_variable}}}", null)
    // route_policy_id = (route_policy) TO BE ADDED AFTER RPL IS IMPLEMENTED
  }]
  ipv4_table_map_filter          = try(each.value.bgp.ipv4_table_map_filter, null)
  ipv4_table_map_filter_variable = try("{{${each.value.bgp.ipv4_table_map_filter_variable}}}", null)
  // ipv4_table_map_route_policy_id (ipv4_table_map_name) TO BE ADDED AFTER RPL IS IMPLEMENTED
  ipv6_aggregate_addresses = try(length(each.value.bgp.ipv6_aggregate_addresses) == 0, true) ? null : [for a in each.value.bgp.ipv6_aggregate_addresses : {
    aggregate_prefix          = try(a.prefix, null)
    aggregate_prefix_variable = try("{{${a.prefix_variable}}}", null)
    as_set_path               = try(a.as_set_path, null)
    as_set_path_variable      = try("{{${a.as_set_path_variable}}}", null)
    summary_only              = try(a.summary_only, null)
    summary_only_variable     = try("{{${a.summary_only_variable}}}", null)
  }]
  ipv6_eibgp_maximum_paths          = try(each.value.bgp.ipv6_eibgp_maximum_paths, null)
  ipv6_eibgp_maximum_paths_variable = try("{{${each.value.bgp.ipv6_eibgp_maximum_paths_variable}}}", null)
  ipv6_neighbors = try(length(each.value.bgp.ipv6_neighbors) == 0, true) ? null : [for neighbor in each.value.bgp.ipv6_neighbors : {
    address          = try(neighbor.address, null)
    address_variable = try("{{${neighbor.address_variable}}}", null)
    address_families = try(length(neighbor.address_families) == 0, true) ? null : [for address_family in neighbor.address_families : {
      family_type = address_family.family_type
      // in_route_policy_id (in_route_policy) TO BE ADDED AFTER RPL IS IMPLEMENTED
      max_number_of_prefixes          = try(address_family.maximum_prefixes_number, null)
      max_number_of_prefixes_variable = try("{{${address_family.maximum_prefixes_number_variable}}}", null)
      // out_route_policy_id (out_route_policy) TO BE ADDED AFTER RPL IS IMPLEMENTED
      policy_type               = try(address_family.maximum_prefixes_reach_policy, null)
      restart_interval          = try(address_family.maximum_prefixes_restart_interval, null)
      restart_interval_variable = try("{{${address_family.maximum_prefixes_restart_interval_variable}}}", null)
      threshold                 = try(address_family.maximum_prefixes_threshold, null)
      threshold_variable        = try("{{${address_family.maximum_prefixes_threshold_variable}}}", null)
    }]
    allowas_in_number                = try(neighbor.allowas_in_number, null)
    allowas_in_number_variable       = try("{{${neighbor.allowas_in_number_variable}}}", null)
    as_override                      = try(neighbor.as_override, null)
    as_override_variable             = try("{{${neighbor.as_override_variable}}}", null)
    description                      = try(neighbor.description, null)
    description_variable             = try("{{${neighbor.description_variable}}}", null)
    ebgp_multihop                    = try(neighbor.ebgp_multihop, null)
    ebgp_multihop_variable           = try("{{${neighbor.ebgp_multihop_variable}}}", null)
    hold_time                        = try(neighbor.hold_time, null)
    hold_time_variable               = try("{{${neighbor.hold_time_variable}}}", null)
    keepalive_time                   = try(neighbor.keepalive_time, null)
    keepalive_time_variable          = try("{{${neighbor.keepalive_time_variable}}}", null)
    local_as                         = try(neighbor.local_as, null)
    local_as_variable                = try("{{${neighbor.local_as_variable}}}", null)
    next_hop_self                    = try(neighbor.next_hop_self, null)
    next_hop_self_variable           = try("{{${neighbor.next_hop_self_variable}}}", null)
    password                         = try(neighbor.password, null)
    password_variable                = try("{{${neighbor.password_variable}}}", null)
    remote_as                        = try(neighbor.remote_as, null)
    remote_as_variable               = try("{{${neighbor.remote_as_variable}}}", null)
    send_community                   = try(neighbor.send_community, null)
    send_community_variable          = try("{{${neighbor.send_community_variable}}}", null)
    send_extended_community          = try(neighbor.send_extended_community, null)
    send_extended_community_variable = try("{{${neighbor.send_extended_community_variable}}}", null)
    send_label                       = try(neighbor.send_label, null)
    shutdown                         = try(neighbor.shutdown, null)
    shutdown_variable                = try("{{${neighbor.shutdown_variable}}}", null)
    update_source_interface          = try(neighbor.source_interface, null)
    update_source_interface_variable = try("{{${neighbor.source_interface_variable}}}", null)
  }]
  ipv6_networks = try(length(each.value.bgp.ipv6_networks) == 0, true) ? null : [for network in each.value.bgp.ipv6_networks : {
    network_prefix          = try(network.prefix, null)
    network_prefix_variable = try("{{${network.prefix_variable}}}", null)
  }]
  ipv6_originate          = try(each.value.bgp.ipv6_default_originate, null)
  ipv6_originate_variable = try("{{${each.value.bgp.ipv6_default_originate_variable}}}", null)
  ipv6_redistributes = try(length(each.value.bgp.ipv6_redistributes) == 0, true) ? null : [for redistribute in each.value.bgp.ipv6_redistributes : {
    protocol          = try(redistribute.protocol, null)
    protocol_variable = try("{{${redistribute.protocol_variable}}}", null)
    // route_policy_id = (route_policy) TO BE ADDED AFTER RPL IS IMPLEMENTED
  }]
  ipv6_table_map_filter          = try(each.value.bgp.ipv6_table_map_filter, null)
  ipv6_table_map_filter_variable = try("{{${each.value.bgp.ipv6_table_map_filter_variable}}}", null)
  // ipv6_table_map_route_policy_id (ipv6_table_map_name) TO BE ADDED AFTER RPL IS IMPLEMENTED
  keepalive_time                 = try(each.value.bgp.keepalive_time, null)
  keepalive_time_variable        = try("{{${each.value.bgp.keepalive_time_variable}}}", null)
  local_routes_distance          = try(each.value.bgp.local_routes_distance, null)
  local_routes_distance_variable = try("{{${each.value.bgp.local_routes_distance_variable}}}", null)
  missing_med_as_worst           = try(each.value.bgp.missing_med_as_worst, null)
  missing_med_as_worst_variable  = try("{{${each.value.bgp.missing_med_as_worst_variable}}}", null)
  mpls_interfaces = try(length(each.value.bgp.mpls_interfaces) == 0, true) ? null : [for interface in each.value.bgp.mpls_interfaces : {
    interface_name          = try(interface.name, null)
    interface_name_variable = try("{{${interface.name_variable}}}", null)
  }]
  multipath_relax              = try(each.value.bgp.multipath_relax, null)
  multipath_relax_variable     = try("{{${each.value.bgp.multipath_relax_variable}}}", null)
  propagate_as_path            = try(each.value.bgp.propagate_as_path, null)
  propagate_as_path_variable   = try("{{${each.value.bgp.propagate_as_path_variable}}}", null)
  propagate_community          = try(each.value.bgp.propagate_community, null)
  propagate_community_variable = try("{{${each.value.bgp.propagate_community_variable}}}", null)
  router_id                    = try(each.value.bgp.router_id, null)
  router_id_variable           = try("{{${each.value.bgp.router_id_variable}}}", null)
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
