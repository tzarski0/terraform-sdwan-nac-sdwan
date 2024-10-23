resource "sdwan_configuration_group" "configuration_group" {
  for_each    = { for g in local.configuration_groups : g.name => g }
  name        = each.value.name
  description = each.value.description
  solution    = try(each.value.solution, "sdwan")
  feature_profiles = flatten([
    try(each.value.cli_profile, null) == null ? [] : [{
      id = sdwan_cli_feature_profile.cli_feature_profile[each.value.cli_profile].id
    }],
    try(each.value.service_profile, null) == null ? [] : [{
      id = sdwan_service_feature_profile.service_feature_profile[each.value.service_profile].id
    }],
    try(each.value.system_profile, null) == null ? [] : [{
      id = sdwan_system_feature_profile.system_feature_profile[each.value.system_profile].id
    }],
    try(each.value.transport_profile, null) == null ? [] : [{
      id = sdwan_transport_feature_profile.transport_feature_profile[each.value.transport_profile].id
    }],
  ])
  topology_site_devices = try(length(each.value.topology_devices), null)
  topology_devices = try(length(each.value.topology_devices) == 0, true) ? null : [for device in each.value.topology_devices : {
    criteria_attribute = "tag"
    criteria_value     = device.tag
    unsupported_features = flatten([
      for feature in try(device.unsupported_basic_features, []) : {
        parcel_type = "wan/vpn/interface/ethernet"
        parcel_id   = sdwan_system_basic_profile_parcel.system_basic_profile_parcel["${each.value.system_profile}-${feature}"].id
      }
    ]),
  }]
}

# resource "sdwan_configuration_group" "configuration_group" {
#   for_each    = { for g in local.configuration_groups : g.name => g }
#   name        = each.value.name
#   description = each.value.description
#   solution    = try(each.value.solution, "sdwan")
#   feature_profiles = flatten([
#     try(each.value.cli_profile, null) == null ? [] : [{
#       id = sdwan_cli_feature_profile.cli_feature_profile[each.value.cli_profile].id
#     }],
#     try(each.value.service_profile, null) == null ? [] : [{
#       id = sdwan_service_feature_profile.service_feature_profile[each.value.service_profile].id
#     }],
#     try(each.value.system_profile, null) == null ? [] : [{
#       id = sdwan_system_feature_profile.system_feature_profile[each.value.system_profile].id
#     }],
#     try(each.value.transport_profile, null) == null ? [] : [{
#       id = sdwan_transport_feature_profile.transport_feature_profile[each.value.transport_profile].id
#     }],
#   ])
#   topology_site_devices = try(length(each.value.topology_devices), null)
#   topology_devices = try(length(each.value.topology_devices) == 0, true) ? [] : [for device in each.value.topology_devices : {
#     criteria_attribute = "tag"
#     criteria_value     = device.tag
#     unsupported_features = flatten([
#       for feature in try(device.unsupported_basic_features, []) : {
#         parcel_type = "wan/vpn/interface/ethernet"
#         parcel_id   = sdwan_system_basic_feature.system_basic_feature["${each.value.system_profile}-${feature}"].id
#       }
#     ]),
#   }]
# }

