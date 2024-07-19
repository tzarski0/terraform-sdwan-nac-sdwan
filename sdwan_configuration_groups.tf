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
}
